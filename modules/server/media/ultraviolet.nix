{
  flake.modules.nixos.server = {

    services.ultraviolet = { 
      enable = true;
      port = 8044;
    };

    systemd.services.ultraviolet.vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    vpnNamespaces.mullvad = {
      portMappings = [
        { 
          from = 8044;
          to = 8044;
        }
      ];
    };

    web_services."ultraviolet" = {
      domains = "local";
      root = {
        proxyPass = "http://192.168.15.1:8044/"; 
      };
    };
  };
}
