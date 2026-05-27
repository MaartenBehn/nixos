{ lib, self, config, ... }: {
  options = {
    users = lib.mkOption {
        type = lib.types.attrsOf (lib.types.submodule {
          options = {
          };
        });
      };
  };

  config.flake.modules = (lib.mergeAttrsList (lib.mapAttrsToList (username: options: {
    nixos.core = { config, ... }: {
      users.users."${username}" = {
        isNormalUser = true;
        description = "${username}";
      };

      imports = [
        self.modules.nixos."${username}" or {}
      ];

      home-manager.users."${username}".imports = [
        self.modules.homeManager.core or {}
        self.modules.homeManager."${username}" or {}
        self.modules.homeManager."${config.networking.hostName}" or {}
        {
          home.username = "${username}";
        }
      ];
    };
  }) config.users));
}
