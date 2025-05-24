{ system, username, modulesPath, ... }: {
 
  imports = [
    "${toString modulesPath}/installer/cd-dvd/installation-cd-base.nix"
  ];

  nixpkgs.hostPlatform = system; 

  services.displayManager.autoLogin = {
    enable = true;
    user = "${username}";
  }; 
}
