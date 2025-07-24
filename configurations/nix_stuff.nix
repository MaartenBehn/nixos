{ nix-version, ... }:
{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = nix-version;

  nixpkgs.config = {
    # Allow unfree packages
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  home-manager.backupFileExtension = "backup-2";

  documentation.nixos.enable = false;
  documentation.man.generateCaches = false;
 
  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-1.1.05"
  ];
}
