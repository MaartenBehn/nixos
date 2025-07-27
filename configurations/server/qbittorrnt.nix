{ pkgs, local_domain, ... }: { 

  imports = [
    ./prowlarr.nix
    ./sonarr.nix
  ];

  # Define VPN network namespace
  vpnNamespaces.wg = {
    enable = true;
    wireguardConfigFile = /home/stroby/.config/wireguard/mullvad.conf;
    accessibleFrom = [
      "192.168.0.0/24"
    ];
    portMappings = [
      { 
        from = 8083;
        to = 8083;
      }
    ];
    openVPNPorts = [{
      port = 11429;
      protocol = "both";
    }
    {
      port = 64215;
      protocol = "both";
    }];
  };


  systemd.services.qbittorrent-nox = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    path = with pkgs; [
      qbittorrent-nox
      curl
    ];
    script = "
    #curl curl ipinfo.io;
    qbittorrent-nox --confirm-legal-notice;
    ";
    wantedBy = [ "multi-user.target" ];
    serviceConfig.User = "stroby";
  };

  
  services.nginx.virtualHosts = {

    "qbittorrent.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://192.168.15.1:8083/"; 
      };

      serverAliases = [
        "www.qbittorrent.${local_domain}"
      ];
    };
  };
}
