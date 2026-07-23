{
  flake.modules.nixos.server = { pkgs, ... }: {
    services.flaresolverr = {
      enable = true;
      port = 8191;
    };

    systemd.services.flaresolverr.vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    vpnNamespaces.mullvad = {
      portMappings = [
        { 
          from = 8191;
          to = 8191;
        }
      ];
    };

    web_services."flaresolverr" = {
      domains = "local";
      root = {
        proxyPass = "http://192.168.15.1:8191/"; 
      };
    };
  };
}
