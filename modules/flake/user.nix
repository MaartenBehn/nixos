{ lib, self, config, ... }: 
let
  username = "stroby";
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
        };
      };

      config = {
        username = username;

        users.users."${username}" = {
          isNormalUser = true;

          extraGroups = [
            "wheel"

            # Move
            "media"
            "nginx"
          ];
        };

        home-manager.users."${username}".imports = [
          {
            username = username;
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
