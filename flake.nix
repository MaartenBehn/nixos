{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:MaartenBehn/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = github:nix-community/plasma-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    }; 
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, plasma-manager, ... }@inputs:
  let 
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    username = "stroby";
  in   
  {
    nixosConfigurations = {
      stroby-laptop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit pkgs-unstable;        
        };
        modules = [
          ./hosts/laptop/configuartion.nix

          inputs.home-manager.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

            home-manager.users.stroby = import ./hosts/laptop/home.nix;
            # home-manager.extraSpecialArgs = {networking; inherit services;};
          }
        ];
      };

      stroby-desktop = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit pkgs-unstable;        
        };
        modules = [
          ./hosts/desktop/configuartion.nix

          inputs.home-manager.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

            home-manager.users.stroby = import ./hosts/desktop/home.nix;
            # home-manager.extraSpecialArgs = {networking; inherit services;};
          }
        ];
      };

      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          username = "nixos";
          inherit pkgs-unstable;        
        };
        modules = [
          ./hosts/wsl/configuartion.nix

          inputs.home-manager.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.nixos = import ./hosts/wsl/home.nix;
            # home-manager.extraSpecialArgs = {networking; inherit services;};
          }
        ];
      };

      asus = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit pkgs-unstable;        
        };
        modules = [
          ./hosts/asus/configuartion.nix

          inputs.home-manager.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

            home-manager.users.stroby = import ./hosts/asus/home.nix;
            # home-manager.extraSpecialArgs = {networking; inherit services;};
          }
        ];
      };

      iso = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs;
          inherit username;
          inherit pkgs-unstable;        
        };
        modules = [
          ./hosts/iso/configuration.nix

          inputs.home-manager.nixosModules.default
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

            home-manager.users.stroby = import ./hosts/iso/home.nix;
            # home-manager.extraSpecialArgs = {networking; inherit services;};
          }
        ];
      };

    };
  };
}
