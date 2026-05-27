{ self , ... }: {
  users.stroby = {};

  flake.modules = {
    nixos.stroby = {
      imports = [
      ];    
    };

    homeManager.stroby = {
      imports = [
        self.modules.homeManager.full-cli or {}
      ];
    };
  };
}
