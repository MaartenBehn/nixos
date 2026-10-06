{ inputs, lib, self, config, ... }: let 
  setting_options = {
    local_ip = lib.mkOption {
      type = lib.types.str;
    };

    domains.public = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    domains.local = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "local" ];
    };

    remote_build = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

in {
  options = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };

          nixos = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };

          homeManager = lib.mkOption {
            type = lib.types.attrs;
            default = {};
          };

        } // setting_options;
      });
    };
  };

  config.flake = let 
    config_setting_options = {

      host = lib.mkOption {
        type = lib.types.str;
      };

      system_type = lib.mkOption {
        type = lib.types.str;
      };

    } // setting_options;

    in {
      modules.nixos.core.options = config_setting_options;
      modules.homeManager.core = config_setting_options;
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
          inherit pkgs;
          inherit (options) system;

          specialArgs = args;
          modules = [
            {
              home-manager.extraSpecialArgs = args;
              host = hostname;
              system_type = options.system; 
              inherit (options) local_ip;
              inherit (options) remote_build;
            }
            self.modules.nixos.core
            options.nixos
          ];
        }) 
      config.hosts;
  };
}
