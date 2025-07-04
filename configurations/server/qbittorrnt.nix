{ pkgs, lib, config, vpn-confinement, ... }: {
  imports = [
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
      { 
        from = 9117;
        to = 9117;
      }
      { 
        from = 8191;
        to = 8191;
      }
    ];
    openVPNPorts = [{
      port = 6758;
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
    curl curl ipinfo.io;
    qbittorrent-nox --confirm-legal-notice;
    ";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];
    serviceConfig.User = "stroby";
  };

  systemd.services.jackett = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "wg";
    };

    path = with pkgs; [
      curl
      jackett
    ];
    script = "
    curl curl ipinfo.io;
    jackett;
    ";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];
    serviceConfig.User = "stroby";
  };

  # Add systemd service to VPN network namespace
  systemd.services.flaresolverr.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  services.flaresolverr = {
    enable = true;
  };
}
