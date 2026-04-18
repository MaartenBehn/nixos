{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-2405.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-2505.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
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
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # https://github.com/Frost-Phoenix/nixos-config/blob/main/flake.nix
    nur.url = "github:nix-community/NUR";
    
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";

    hyprland.url = "github:hyprwm/Hyprland";

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hyprmag.url = "github:SIMULATAN/hyprmag";

    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    yazi-plugins = {
      url = "github:yazi-rs/plugins";
      flake = false;
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    zig.url = "github:mitchellh/zig-overlay";

    nvf.url = "github:notashelf/nvf";

    solaar = {
      url = "https://flakehub.com/f/Svenum/Solaar-Flake/*.tar.gz"; # For latest stable version
      #url = "https://flakehub.com/f/Svenum/Solaar-Flake/0.1.1.tar.gz"; # uncomment line for solaar version 1.1.13
      #url = "github:Svenum/Solaar-Flake/main"; # Uncomment line for latest unstable version
      inputs.nixpkgs.follows = "nixpkgs";
    };

    vpn-confinement.url = "github:Maroka-chan/VPN-Confinement";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neko = {
      url = "github:MaartenBehn/neko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, nixpkgs-2405, nixpkgs-2505, plasma-manager, solaar, vpn-confinement, ... }@inputs:

  let 
    system = "x86_64-linux";
    nix-version = "25.11";
    hosts = [ "laptop" "desktop" "stroby" "asus" "wsl" "iso" ];

    pkgs-2405 = import nixpkgs-2405 {
        inherit system;
        config.allowUnfree = true;
    };
    pkgs-2505 = import nixpkgs-2505 {
        inherit system;
        config.allowUnfree = true;
    };
    pkgs-unstable = import nixpkgs-unstable {
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
      nixosConfigurations = builtins.listToAttrs (builtins.map (host:
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
          value = nixpkgs.lib.nixosSystem {
            inherit system; # system = system
            specialArgs = args;
            modules = [
              ./configurations

              inputs.home-manager.nixosModules.default
              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users."stroby" = import ./home;
                home-manager.extraSpecialArgs = args;
              }
            ];
          };
        } ) hosts);
    };
}
