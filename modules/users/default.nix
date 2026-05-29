{ lib, self, config, ... }: {
  options = {
    users = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          nixos = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule {});
            default = [];
          };

          homeManager = lib.mkOption {
            type = lib.types.listOf (lib.types.submodule {});
            default = [];
          }; 
        };
      });
    };
  };

  config.flake = {
    modules = {
      homeManager.core = {
        options = {
          username = lib.mkOption {
            type = lib.types.str;
          };
        };
      };

    } // (lib.mergeAttrsList (lib.mapAttrsToList (username: options: {
      nixos.core = { config, ... }: {
        users.users."${username}" = {
          isNormalUser = true;
          description = "${username}";
        };

        imports = [
          options.nixos
          self.modules.nixos."${username}" or {}
        ];

        home-manager.users."${username}".imports = [
          {
            username = "${username}";
            home.username = "${username}";
          }
          options.homeManager
          self.modules.homeManager.core or {}
          self.modules.homeManager."${username}" or {}
          self.modules.homeManager."${config.host}" or {}

        ];
      };
    }) config.users));
  };
}
