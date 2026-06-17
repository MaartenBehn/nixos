{ inputs, self, ... }: 
let 
  system = "x86_64-linux";
  nix-version = "25.11";
  
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
  
  args = {
    inherit inputs;
    inherit pkgs-2405;
    inherit pkgs-2505;
    inherit pkgs-unstable;  
  };

  old-imports = [
    {
      home-manager.extraSpecialArgs = args;
    }
  ];
in {
  hosts.stroby-laptop = {
    args = args;

    nixos = {
      imports = old-imports ++ 
        (with self.modules.nixos; [
          framework
          fix_tpm2
          networking
          networking_vpn
          bluetooth
          battery
          syncthing
          fingerprint
          smb
          cli
          cli-full
          hyprland
          intel-graphics
          apps-minimal
          apps
          code
          projects_tauri
          games
        ]);
    };

    homeManager = {
      imports = with self.modules.homeManager; [
        solaar
        cli
        cli-full
        hyprland
        battery-hyprland-notifications
        apps-minimal
        apps
        code
      ];

      home.sessionVariables.terminal = "kitty";
    };
  };
}
