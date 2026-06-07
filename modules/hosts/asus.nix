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
    inherit nix-version;
    inherit system;
    inherit inputs;
    inherit pkgs-2405;
    inherit pkgs-2505;
    inherit pkgs-unstable;  
    host = "asus";
    system_name = mkSystemName "asus";
  };

  old-imports = [
    ../../configurations

    {
      home-manager.extraSpecialArgs = args;
    }
  ];
in {
  hosts.stroby-asus = {
    args = args;

    nixos = {
      imports = old-imports ++ 
        (with self.modules.nixos; [
        ]);
    };

    homeManager = {
      imports = with self.modules.homeManager; [
        cli
      ];

      home.sessionVariables.terminal = "kitty";
    };
  };
}
