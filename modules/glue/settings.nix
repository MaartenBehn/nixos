{ inputs, lib, self, config, ... }: let 
  setting_options = {
    local_ip = lib.mkOption {
      type = lib.types.str;
    };

    domains.public = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };

    domains.local = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "local" ];
    };

    remote_build = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config_setting_options = {

    host = lib.mkOption {
      type = lib.types.str;
    };

    system_type = lib.mkOption {
      type = lib.types.str;
    };

  } // setting_options;

  inherit_settings = config: lib.mapAttrs (option_name: _: config.${option_name}) setting_options; 

in {
  options = {
    hosts = lib.mkOption {
      type = lib.types.attrsOf (lib.types.submodule {
        options = setting_options;
      });
    };
  };

  config.flake = {
    modules.nixos.core.options = config_setting_options;
    modules.homeManager.core = config_setting_options;

    nixosConfigurations = lib.mapAttrs (hostname: options: inputs.nixpkgs.lib.nixosSystem {
      modules = [
        ({
          host = hostname;
          system_type = options.system;
        } // (inherit_settings options))
      ];
    }) config.hosts;

    nixos.core = { config, ... }: {
      home-manager.users."${config.username}".imports = [
        ({
          inherit (config) username;
          inherit (config) host;
          inherit (config) system_type;
        } // (inherit_settings config))
      ];
    };
  };
}
