{ lib, config, ... }: 
let 
  parts_config = config;
in {
  options = {
    users = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
          };
        });
      };
  };

  config.flake.modules = (lib.mergeAttrsList (lib.mapAttrsToList (username: options: {
    nixos.core = {
      users.users."${username}" = {
        isNormalUser = true;
        description = "${username}";
      };

      imports = [
        parts_config.flake.modules.nixos."${username}" or {}
      ];

      home-manager.users."${username}".imports = [
        parts_config.flake.modules.homeManager.core or {}
        parts_config.flake.modules.homeManager."${username}" or {}
        {
          home.username = "${username}";
        }
      ];
    };
  }) { stroby = {}; }));
}
