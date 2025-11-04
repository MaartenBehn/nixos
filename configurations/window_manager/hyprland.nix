{ lib, pkgs, inputs, username, ... }: {
 
  #services.xserver.enable = false;
  services.libinput.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  }; 

  services.getty.autologinUser = username;
  console.enable = true;

  # Disable wait for online befor login
  systemd.services."NetworkManager-wait-online".enable = false;
  
  programs.hyprland = {
    enable = true;

    package = inputs.hyprland.packages.${pkgs.system}.default;
    portalPackage =
      inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      hyprland.default = [
        "gtk"
        "hyprland"
      ];
    };

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };

  security.pam.services.hyprlock = {
    allowNullPassword = false;
    startSession = false;
    text = ''
      auth    include login
      account include login
    '';
  };
}
