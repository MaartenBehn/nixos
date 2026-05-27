{ inputs, config, ... }: 
let 
  version = config.version;
in {
  
  flake.modules = {
    nixos.core = {
      imports = [ 
        inputs.home-manager.nixosModules.default
        inputs.home-manager.nixosModules.home-manager 
      ];

      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true; 
        extraSpecialArgs.inputs = inputs;
      };
    };

    homeManager.core = { config, ... }: {
      programs.home-manager = {
        enable = true;
      };

      home.stateVersion = version;  
      home.homeDirectory = "/home/${config.home.username}";
    };
  };
}
