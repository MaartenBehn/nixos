{ config, self, ... }: let
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

    home-manager.users.${config.username}.imports = builtins.map 
      (name: self.modules.homeManager.${name} or {}) global_config.hosts.${config.host}.modules;
  };
}
