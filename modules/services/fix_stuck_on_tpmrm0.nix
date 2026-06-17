{
  flake.modules.nixos.fix_tpm2 =  { ... }: {
    systemd.tpm2.enable = false;
  };
}
