{
  flake.modules.nixos.server = {

    services.scramjet = { 
      enable = true;
      port = 8055;
    };

    systemd.services.scramjet.vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    vpnNamespaces.mullvad = {
      portMappings = [
        { 
          from = 8055;
          to = 8055;
        }
      ];
    };

    web_services."sonarr" = {
      domains = "local";
      root = {
        proxyPass = "http://192.168.15.1:8055/"; 
      };
    };
  };
}

