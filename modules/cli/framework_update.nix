{
  flake.modules.nixos.framework = {
    services.fwupd.enable = true;
  };
}
