{ self , ... }: {
  users.stroby = {};

  flake.modules = {
    nixos.stroby = {
      imports = [
      ];    
    };

    homeManager.stroby = {
      username = "stroby";

      imports = [
        self.modules.homeManager.full-cli or {}
        self.modules.homeManager.apps-minimal or {}
        self.modules.homeManager.apps or {}
      ];
    };
  };
}
