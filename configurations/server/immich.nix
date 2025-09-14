{ domains, local_domain, config, ... }: {
  services.immich = {
    enable = true;
    port = 2283;
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "immich.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';      
      };

      serverAliases = [
        "www.immich.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
