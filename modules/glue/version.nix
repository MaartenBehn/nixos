{ lib, config, ... }: {
  options.version = lib.mkOption {
    type = lib.types.str;
    default = "26.05";
  };

  config.flake.modules.nixos.core = {
    system.stateVersion = config.version;
  };
}
