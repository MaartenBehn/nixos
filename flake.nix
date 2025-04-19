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
  };
  

  outputs = { self, nixpkgs, nixpkgs-unstable, plasma-manager, ... }@inputs:

  let 
    system = "x86_64-linux";
    lib = nixpkgs.lib;
    pkgs = nixpkgs.legacyPackages.${system};
    pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};

    configs = [
      {
        host = "laptop";
        username = "stroby"; 
        terminal = "kitty";
        desktop = "hyprland";
      }
      {
        host = "desktop";
        username = "stroby";
        terminal = "kitty";
        desktop = "plasma5";
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
      }
    ];

    add_optional = name: (val: if (builtins.hasAttr name val) then val."${name}" else null); 
  in   
  {
    # Generate configs
    nixosConfigurations = builtins.listToAttrs (builtins.map (config: 
      { 
        # Name of the config
        name = "${config.username}-${config.host}"; 

        # Content of the config
        value = nixpkgs.lib.nixosSystem {
          inherit system; # system = system
          specialArgs = {
            inherit system;
            inherit inputs;
            inherit pkgs-unstable;   
            username = config.username;
            host = config.host;
            terminal = (add_optional "terminal" config);
            desktop = (add_optional "desktop" config);

            add_optional = add_optional;
          };
          modules = [
            ./hosts/${config.host}/configuartion.nix

            inputs.home-manager.nixosModules.default
            inputs.home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.sharedModules = [ plasma-manager.homeManagerModules.plasma-manager ];

              home-manager.users.stroby = import ./hosts/${config.host}/home.nix;
              home-manager.extraSpecialArgs = { 
                inherit system;
                inherit inputs;
                inherit pkgs-unstable;
                username = config.username;
                host = config.host;
                terminal = (add_optional "terminal" config);
                desktop = (add_optional "desktop" config);
                
                add_optional = add_optional;
              };
            }
          ];
        };
      } ) configs);
  };
}
