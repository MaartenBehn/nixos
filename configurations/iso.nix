{ system, username, modulesPath, ... }: {
 
  imports = [
    "${toString modulesPath}/installer/cd-dvd/iso-image.nix"
  ];

  # EFI booting
  isoImage.makeEfiBootable = true;

  # USB booting
  isoImage.makeUsbBootable = true;

  nixpkgs.hostPlatform = system; 

  services.displayManager.autoLogin = {
    enable = true;
    user = "${username}";
  };
}
