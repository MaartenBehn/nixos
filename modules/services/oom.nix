{
  flake.modules.nixos.core = { config , ...}: {
    services.systemd-oomd.enable = true;
  };
}
