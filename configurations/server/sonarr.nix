{ local_domain, ... }: {
  users.groups.media.members = [ "sonarr" ];

  services.sonarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.sonarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 8989;
        to = 8989;
      }
    ];
  };

  web_services."sonarr" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:8989/"; 
    };
  };
}


