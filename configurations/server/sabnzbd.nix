{ pkgs, ... }: {
  users.groups.media.members = [ "sabnzbd" ];

  systemd.services.radarr = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    path = with pkgs; [
      sabnzbd
    ];
    script = "sabnzbd -s 0.0.0.0:7979";

    serviceConfig = {
      User = "sabnzbd";
    };
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 7979;
        to = 7979;
      }
    ];
  };

  web_services."sabnzbd" = {
    domains = "local";
    loc = {
      proxyPass = "http://192.168.15.1:7979/"; 
    };
  };
} 
