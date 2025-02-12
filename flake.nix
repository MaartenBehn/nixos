{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:MaartenBehn/nixvim";
    };

    nix-minecraft.url = "github:Infinidoge/nix-minecraft";

    plasma-manager = {
      url = github:nix-community/plasma-manager;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    }; 
  };

  outputs =
    { self, nixpkgs, plasma-manager, ... }@inputs:
    {
      nixosConfigurations.stroby-laptop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
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

      nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
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

      nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
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

      nixosConfigurations.asus = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
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

    };
}
