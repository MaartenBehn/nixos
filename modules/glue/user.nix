{ lib, self, config, ... }: 
let
  global_config = config;
in {
  flake.modules.nixos.core = { config, ... }: {

    users.users."${config.username}" = {
      isNormalUser = true;

      extraGroups = [
        "wheel"

        # Move
        "media"
        "nginx"
      ];
    };

    home-manager.users.${config.username}.imports = [
      self.modules.homeManager.core or {}
      self.modules.homeManager.${config.host} or {}
      global_config.hosts.${config.host}.homeManager
    ];
  };
}
