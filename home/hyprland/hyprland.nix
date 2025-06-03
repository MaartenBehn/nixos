{ inputs, pkgs, ... }:
{
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    
    # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
    package = null;
    portalPackage = null;

    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };

  home.packages = with pkgs; [
    # eduroam installer    
    python3

    killall
    
    swww
    #inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    grimblast
    hyprpicker
    #inputs.hyprmag.packages.${pkgs.system}.hyprmag
    #hyprmag
    grim
    slurp
    wl-clip-persist
    cliphist
    wf-recorder
    glib
    wayland

    networkmanagerapplet
    seahorse
    blueberry
    btop
    poweralertd                       # Battery notifications    
  ];
}
