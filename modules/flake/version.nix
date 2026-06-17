{ lib, config, ... }: {
  options.version = lib.mkOption {
    type = lib.types.str;
    default = "25.11";
  };

  config.flake.modules.nixos.core = {
    system.stateVersion = config.version;
  };
}
