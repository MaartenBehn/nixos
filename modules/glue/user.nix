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
      options = {
        username = lib.mkOption {
          type = lib.types.str;
          default = "stroby";
        };
      };

      config = {
        users.users."${config.username}" = {
          isNormalUser = true;

          extraGroups = [
            "wheel"

            # Move
            "media"
            "nginx"
          ];
        };

        home-manager.users."${config.username}".imports = [
          {
            username = config.username;
            host = config.host;
            system_type = config.system_type;
          }
          self.modules.homeManager.core or {}
          global_config.hosts."${config.host}".homeManager
        ];
      };
    };
  };
}
