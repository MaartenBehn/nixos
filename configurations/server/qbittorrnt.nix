{ pkgs, local_domain, config , ... }: { 

  imports = [
    ./prowlarr.nix
    ./sonarr.nix
    ./radarr.nix
    ./lidarr.nix
    ./whisparr.nix
  ];

  sops.secrets."wireguard/mullvad.conf" = { owner = "stroby"; };

  # Define VPN network namespace
  vpnNamespaces.mullvad = {
    enable = true;
    #wireguardConfigFile = config.sops.secrets."wireguard/mullvad.conf".path;
    wireguardConfigFile = "/home/stroby/.config/wireguard/mullvad.conf";
    
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
      vpnNamespace = "mullvad";
    };

    path = with pkgs; [
      qbittorrent-nox
      curl
    ];
    script = "
      curl ipinfo.io;
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
