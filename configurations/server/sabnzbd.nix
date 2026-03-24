{ pkgs, ... }: {

  users.users.sabnzbd = {
    isNormalUser = true;
    group = "media";
  };

  systemd.services.sabnzbd = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    path = with pkgs; [
      sabnzbd
    ];
    script = "sabnzbd -s 0.0.0.0:7979";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];

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
