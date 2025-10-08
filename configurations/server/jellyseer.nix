{ local_domain, domains, ... }: {
  services.jellyseerr = {
    enable = true;
    port = 5055;
  };

  systemd.services.jellyseerr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 5055;
        to = 5055;
      }
    ];
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "seerr.${domain}"; 
    value = { 
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        proxyPass = "http://192.168.15.1:5055/";
        proxyWebsockets = true;
      };

      serverAliases = [
        "www.seerr.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
} 
