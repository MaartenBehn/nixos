{ inputs, lib, self, config, ... }: {
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
        };
      });
    };
  };

  config.flake = {
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
            }
            self.modules.nixos.core
            self.modules.nixos.${hostname}
            options.nixos
          ];
        }) 
      config.hosts;
  };
}
