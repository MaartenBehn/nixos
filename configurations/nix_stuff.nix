{ pkgs, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "24.11";

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  home-manager.backupFileExtension = "backup";

  # To fix long nix build times
  documentation.man.generateCaches = false;
}
