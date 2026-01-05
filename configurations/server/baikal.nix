{ config, ... }: {
  services.baikal = {
    enable = true;
  };
  nixpkgs.config.allowBroken = true;

  # Overerride the nginx config from:
  # https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/web-apps/baikal.nix
  # 
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "baikal.${domain}"; 
    value = {
      enableACME = domain != "local";
      forceSSL = domain != "local";
      root = "${config.services.baikal.package}/share/php/baikal/html";
      locations = {
        "/" = {
          index = "index.php";
          extraConfig = ''
            client_max_body_size 50000M;
            proxy_read_timeout   600s;
            proxy_send_timeout   600s;
            send_timeout         600s;
          '';
        };
        "/.well-known/".extraConfig = ''
            rewrite ^/.well-known/caldav  /dav.php redirect;
            rewrite ^/.well-known/carddav /dav.php redirect;
        '';
        "~ /(\.ht|Core|Specific|config)".extraConfig = ''
            deny all;
            return 404;
        '';
        "~ ^(.+\.php)(.*)$".extraConfig = ''
            try_files $fastcgi_script_name =404;
            include                   ${config.services.nginx.package}/conf/fastcgi.conf;
            fastcgi_split_path_info   ^(.+\.php)(.*)$;
            fastcgi_pass              unix:${config.services.phpfpm.pools.${config.services.baikal.pool}.socket};
            fastcgi_param             SCRIPT_FILENAME  $document_root$fastcgi_script_name;
            fastcgi_param             PATH_INFO        $fastcgi_path_info;
        '';      };

      serverAliases = [
        "www.baikal.${domain}"
      ];
    };
  }) (config.domains.all));
}
