{ pkgs, ... }: {
  containers.private.config = {
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

    services.nginx.virtualHosts = let
      SSL = {
        enableACME = true;
        forceSSL = true;
      }; in {

      "qbittorrent.home" = (SSL // {
        locations."/" = {
          proxyPass = "http://192.168.15.1:8083/"; 
        };

        serverAliases = [
          "www.qbittorrent.home"
        ];
      });

      "jackett.home" = (SSL // {
        locations."/" = {
          proxyPass = "http://192.168.15.1:9117/"; 
        };

        serverAliases = [
          "www.jackett.home"
        ];
      });

      "flaresolverr.home" = (SSL // {
        locations."/" = {
          proxyPass = "http://192.168.15.1:8191/"; 
        };

        serverAliases = [
          "www.jackett.home"
        ];
      });
    };
  };
}
