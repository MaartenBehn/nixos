{ inputs, lib, self, config, ... }: {
  options = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          system = lib.mkOption {
            type = lib.types.str;
            default = "x86_64-linux";
          };

          unstable = lib.mkOption {
            type = lib.types.bool;
            default = false;
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
        nixpkgs' = if options.unstable then inputs.nixpkgs-unstable else inputs.nixpkgs;
      in
        nixpkgs'.lib.nixosSystem {
          inherit (options) system;

          pkgs = import inputs.nixpkgs {
            inherit (options) system;
            config = {
              allowUnfree = true;
              allowUnsupportedSystem = true;
              allowBroken = true;
              permittedInsecurePackages = [
                "ventoy-1.1.05"
              ];
            };
          }; 

          specialArgs = { inherit inputs; } // options.args;
          modules = [
            {
              host = hostname;
              system_type = options.system; 
              networking.hostName = "${hostname}";
            }
            self.modules.nixos.core
            options.nixos
          ];
        }) 
      config.hosts;
  };
}
