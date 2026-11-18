{
  flake.modules.nixos.server = { pkgs, config, ... }: {
    users.groups.media.members = [ "sabnzbd" ];

    services.sabnzbd = {
      enable = true;
      configFile = null;
      
      settings = {
        misc = {
          host = "0.0.0.0";
          port = 7979;
          host_whitelist = "sabnzbd.${config.domains.local}";
        }; 
      };
    };

    systemd.services.sabnzbd = {
      vpnConfinement = {
        enable = true;
        vpnNamespace = "mullvad";
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
      root = {
        proxyPass = "http://192.168.15.1:7979/"; 
      };
    };
  }; 
}
