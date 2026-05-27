{inputs, ... }:
let 
  system = "x86_64-linux";
  nix-version = "25.11";
  hosts = [ "desktop" "asus" "wsl" "iso" ];

  pkgs = import inputs.nixpkgs {
    inherit system;
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
      permittedInsecurePackages = [
        "ventoy-1.1.05"
      ];
    };
  }; 

  pkgs-2405 = import inputs.nixpkgs-2405 {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-2505 = import inputs.nixpkgs-2505 {
    inherit system;
    config.allowUnfree = true;
  };
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;
  };

  mkSystemName = host: 
    (if host == "iso" then "iso" else   
      (if host == "wsl" then "wsl" else   
        "stroby-${host}")); 
in   
  {
  # Generate configs
  flake.nixosConfigurations = builtins.listToAttrs (builtins.map (host:
    let 
      args = {
        inherit nix-version;
        inherit system;
        inherit inputs;
        inherit pkgs-2405;
        inherit pkgs-2505;
        inherit pkgs-unstable;  
        host = host;
        system_name = mkSystemName host;
      }; 
    in { 
      # Name of the config
      name = mkSystemName host; 
      # Content of the config
      value = inputs.nixpkgs.lib.nixosSystem {
        inherit system; # system = system
        inherit pkgs;
        specialArgs = args;
        modules = [
          ../configurations

          inputs.home-manager.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users."stroby" = import ../home;
            home-manager.extraSpecialArgs = args;
          }
        ];
      };
    } ) hosts);
}
