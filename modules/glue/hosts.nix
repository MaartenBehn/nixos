{ inputs, lib, self, config, ... }: {
  options = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };

          args = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };

          nixos = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };

          homeManager = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };
        };
      });
    };
  };

  config.flake = {
    modules.nixos.core = {
      options = {
        host = lib.mkOption {
          type = lib.types.str;
        };
        system_type = lib.mkOption {
          type = lib.types.str;
        };
      };
    };

    modules.homeManager.core = {
      options = {
        host = lib.mkOption {
          type = lib.types.str;
        };
        system_type = lib.mkOption {
          type = lib.types.str;
        };
      };
    };

    nixosConfigurations = lib.mapAttrs (hostname: options:
      let
        pkgs = import inputs.nixpkgs {
          inherit (options) system;
          config = {
            allowUnfree = true;
            allowUnsupportedSystem = true;
            allowBroken = true;
            permittedInsecurePackages = [
              "ventoy-1.1.05"
              "docker-28.5.2"
            ];
          };
        }; 

        pkgs-2405 = import inputs.nixpkgs-2405 {
          inherit (options) system;
          config.allowUnfree = true;
        };
        pkgs-2505 = import inputs.nixpkgs-2505 {
          inherit (options) system;
          config.allowUnfree = true;
        };
        pkgs-unstable = import inputs.nixpkgs-unstable {
          inherit (options) system;
          config.allowUnfree = true;
        };

        args = { 
          inherit (options) system;
          inherit inputs;
          inherit pkgs-2405;
          inherit pkgs-2505;
          inherit pkgs-unstable;
        }; 
      in
        inputs.nixpkgs.lib.nixosSystem {
          inherit (options) system;
          inherit pkgs;

          specialArgs = args;
          modules = [
            {
              home-manager.extraSpecialArgs = args;
              host = hostname;
              system_type = options.system; 
            }
            self.modules.nixos.core
            options.nixos
          ];
        }) 
      config.hosts;
  };
}
