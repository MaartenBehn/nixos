{ inputs, ... }: {
  flake.modules.nixos.server = {

    imports = [
      "${inputs.nixpkgs-scramjet}/nixos/modules/services/web-apps/scramjet.nix"
      {
        nixpkgs.overlays = [
          (final: prev: {
            wanderer = inputs.nixpkgs-wanderer.legacyPackages.${prev.system}.scramjet;
          })
        ];
      }
    ];

    services.scramjet = { 
      demoPort = 4141;
      wispPort = 4142;
      wispUrl = "wss://wsip.local";    
    };

    systemd.services.scramjet.vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };

    vpnNamespaces.mullvad = {
      portMappings = [
        { 
          from = 4141;
          to = 4141;
        }
        { 
          from = 4142;
          to = 4142;
        }
      ];
    };

    web_services."scramjet" = {
      domains = "local";
      root = {
        proxyPass = "http://192.168.15.1:4141/"; 
      };
    };

    web_services."wisp" = {
      domains = "local";
      root = {
        proxyPass = "http://192.168.15.1:4142/"; 
      };
    };
  };
}

