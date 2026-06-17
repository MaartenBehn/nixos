{
  flake.modules.nixos.apps = { ... }: {
    services.printing.enable = true;
  };
}
