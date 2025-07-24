{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
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

    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";

    nix-gaming.url = "github:fufexan/nix-gaming";

    hyprland.url = "github:hyprwm/Hyprland";

    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprmag.url = "github:SIMULATAN/hyprmag";

    nix-flatpak.url = "github:gmodena/nix-flatpak";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";

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
  };
  
  outputs = { self, nixpkgs, nixpkgs-unstable, plasma-manager, solaar, vpn-confinement, ... }@inputs:

  let 
    system = "x86_64-linux";
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    nix-version = "25.05";

    configs = [
      {
        host = "laptop";
        username = "stroby"; 
        terminal = "kitty";
        desktop = "hyprland";
        domain = "stroby.ipv64.de";
      }
      {
        host = "desktop";
        username = "stroby";
        terminal = "kitty";
        desktop = "hyprland";
      }
      {
        host = "asus";
        username = "stroby"; 
      }
      {
        host = "wsl";
        username = "nixos"; 
      }
      {
        host = "iso";
        username = "stroby"; 
        terminal = "kitty";
        desktop = "hyprland";
        domain = "stroby.duckdns.org";
      }
    ];

    add_optional = name: (val: (else_val:  if (builtins.hasAttr name val) then val."${name}" else else_val));
    mkSystemName = config: 
        (if config.host == "iso" then "iso" else   
        (if config.host == "wsl" then "wsl" else   
        "${config.username}-${config.host}")); 

  in   
  {
    # Generate configs
    nixosConfigurations = builtins.listToAttrs (builtins.map (config: 
      { 
        # Name of the config
        name = mkSystemName config; 
        # Content of the config
        value = nixpkgs.lib.nixosSystem {
          inherit system; # system = system
          specialArgs = {
            inherit nix-version;
            inherit system;
            inherit inputs;
            inherit pkgs-unstable;   
            username = config.username;
            host = config.host;
            system_name = mkSystemName config;
            terminal = (add_optional "terminal" config null);
            desktop = (add_optional "desktop" config null);
            domain = (add_optional "domain" config null);

            add_optional = add_optional;
          };
          modules = [
            ./configurations

            inputs.home-manager.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

              home-manager.users."${config.username}" = import ./home;
              home-manager.extraSpecialArgs = { 
                inherit nix-version;
                inherit system;
                inherit inputs;
                inherit pkgs-unstable;
                username = config.username;
                host = config.host;
                system_name = mkSystemName config;
                terminal = (add_optional "terminal" config null);
                desktop = (add_optional "desktop" config null);
                domain = (add_optional "domain" config null);
                
                add_optional = add_optional;
              };
            }

            solaar.nixosModules.default
            vpn-confinement.nixosModules.default
          ];
        };
      } ) configs);
  };
}
