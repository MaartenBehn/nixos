{
  flake.modules.nixos.server = { pkgs, ... }: {
    boot.extraModprobeConfig = ''
      options iwlwifi power_save=0
      options iwlmvm power_scheme=1
    '';
  };
}
