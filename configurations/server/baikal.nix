{ local_domain, domains, config, ... }: {
  services.baikal = {
    enable = true;
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "baikal.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        root = "${config.services.baikal.package}/share/php/baikal/html";
        locations = {
          "/" = {
            index = "index.php";
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
    };
  }) (domains ++ [ local_domain ]));
}
