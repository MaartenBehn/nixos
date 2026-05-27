{ self , ... }: {
  users.stroby = {};

  flake.modules = {
    nixos.stroby = {
    
    };

    homeManager.stroby = {
      imports = [
        self.modules.homeManager.full or {}
      ];
    };
  };
}
