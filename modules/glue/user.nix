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
            inherit (config) username;
            inherit (config) host;
            inherit (config) system_type;
            inherit (config) local_ip;
            inherit (config) remote_build;
          }
          self.modules.homeManager.core or {}
          global_config.hosts."${config.host}".homeManager
        ];
      };
    };
  };
}
