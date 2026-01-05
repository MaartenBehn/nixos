{ ... }: {
  users.groups.media.members = [ "radarr" ];

  services.radarr = { 
    enable = true;
    openFirewall = false;
  };

  systemd.services.radarr.vpnConfinement = {
    enable = true;
    vpnNamespace = "mullvad";
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 7878;
        to = 7878;
      }
    ];
  };

  web_services."radarr" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:7878/"; 
    };
  };
}
