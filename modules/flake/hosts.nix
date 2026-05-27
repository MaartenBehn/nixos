{ inputs, lib, config, ... }: {
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
          };
        });
      };
  };

  config.flake = {
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
              permittedInsecurePackages = [
                "ventoy-1.1.05"
              ];
            };
          }; 

          specialArgs = { inherit inputs; } // options.args;
          modules = [
            config.flake.modules.nixos.core
            (config.flake.modules.nixos."${hostname}" or { })
            {
              networking.hostName = "${hostname}";
            }
          ];
        }) 
      config.hosts;
    
    # So it allways exists
    modules.nixos.core = {};
  };
}
