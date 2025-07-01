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
        from = 8080;
        to = 8083;
      }
    ];
    openVPNPorts = [{
      #port = 60729;
      #protocol = "both";
    }];
  };

  systemd.services.qbittorrent-nox = {
    enable = true;
    vpnNamespace = "wg";
    path = with pkgs; [
      qbittorrent-nox
    ];
    script = "qbittorrent-nox --confirm-legal-notice";
    wantedBy = [ "network-online.target" ];
    after = [ "network.target" ];
  };

}
