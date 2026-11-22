{
  flake.modules.nixos.server = { config, ... }: {
    services.baikal = {
      enable = true;
      virtualHost = null;
    };

    # Overerride the nginx config from:
    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable/nixos/modules/services/web-apps/baikal.nix
    # 
    services.nginx.virtualHosts."baikal.${config.domains.public}" = {
      useACMEHost = config.domains.public;
      forceSSL = true;
      listenAddresses = [ "0.0.0.0" "10.1.0.2" "10.2.0.1" "[::]" "[fd00:11::2]" "[fd00:12::1]" ];
      root = "${config.services.baikal.package}/share/php/baikal/html";
      locations = {
        "/" = {
          index = "index.php";
        };
        "/.well-known/".extraConfig = ''
          rewrite ^/.well-known/caldav  /dav.php redirect;
          rewrite ^/.well-known/carddav /dav.php redirect;
        '';
        "~ /(\\.ht|Core|Specific|config)".extraConfig = ''
          deny all;
          return 404;
        '';
        "~ ^(.+\\.php)(.*)$".extraConfig = ''
          try_files $fastcgi_script_name =404;
          include                   ${config.services.nginx.package}/conf/fastcgi.conf;
          fastcgi_split_path_info   ^(.+\.php)(.*)$;
          fastcgi_pass              unix:${config.services.phpfpm.pools.${config.services.baikal.pool}.socket};
          fastcgi_param             SCRIPT_FILENAME  $document_root$fastcgi_script_name;
          fastcgi_param             PATH_INFO        $fastcgi_path_info;
        '';      
      };

      serverAliases = [
        "www.baikal.${config.domains.public}"
      ];
    };
  };
}
