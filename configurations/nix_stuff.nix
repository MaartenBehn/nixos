{ nix-version, pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
    "pipe-operators"
  ];

  system.stateVersion = nix-version;

  home-manager.backupFileExtension = "backup-2";

  documentation.nixos.enable = false;
  documentation.man.generateCaches = false;
}
