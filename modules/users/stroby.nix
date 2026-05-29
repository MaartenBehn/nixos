{ self , ... }: {
  users.stroby = {
    nixos.imports = [

    ];

    homeManager.imports = [
      self.modules.homeManager.full-cli or {}
      self.modules.homeManager.apps-minimal or {}
      self.modules.homeManager.apps or {}
    ];
  };
}
