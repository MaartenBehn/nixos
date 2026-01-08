{ local_domain, ... }: {
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

  web_services."seerr" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:5055/"; 
    };
  };
} 
