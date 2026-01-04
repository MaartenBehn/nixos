{ lib, config, ... }: {
  options = {
    domains.public = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
    };

    domains.all = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "local" ] ++ config.domains.public;
    };
  };
}
