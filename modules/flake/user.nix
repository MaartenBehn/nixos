{ lib, self, config, ... }: 
let 
  global_config = config;
in {
  config.flake.modules = {
    homeManager.core = {
      options = {
        username = lib.mkOption {
          type = lib.types.str;
        };
      };
    };

    nixos.core = { config, ... }: {
      users.users.stroby = {
        isNormalUser = true;
      };

      home-manager.users.stroby.imports = [
        {
          username = "stroby";
          host = config.host;
          system_type = config.system_type;
        }
        self.modules.homeManager.core or {}
        global_config.hosts."${config.host}".homeManager
      ];
    };
  };
}
