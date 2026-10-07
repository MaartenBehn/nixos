{ lib, config, ... }: let 
  setting_options = {
    username = lib.mkOption {
      type = lib.types.str;
      default = "stroby";
    };

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

    # We have to split the setting in ${hostname}_nixos_settings and ${hostname}_homeManager_settings 
    # bcause we need config for ${hostname}_homeManager_settings but ${hostname}_nixos_settings but the setting need to be
    # direct sets fo the settings propergate into other modules like core or server
    modules.nixos = lib.mergeAttrsList (lib.mapAttrsToList (hostname: options: let
      settings = {
        options = config_setting_options;
        config = {
          host = hostname;
          system_type = options.system;
        } // (inherit_settings options); 
      };
    in {
      "${hostname}_nixos_settings" = settings;
      "${hostname}_homeManager_settings" = { config, ... }: { 
        config.home-manager.users.${config.username}.imports = [
          settings 
          {
            inherit (config) username;
          }
        ];
      };
    }) config.hosts);
  };
}
