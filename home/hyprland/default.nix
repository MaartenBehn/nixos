{ pkgs, pkgs-unstable, host, ... }:
{
  imports = [
    ./hyprland.nix
    ./config.nix
    ./variables.nix
    ./scripts
    
    ./swaync/swaync.nix
    ./waybar
    ./waypaper.nix
    ./gtk.nix
    ./rofi.nix
    ./swayosd.nix                     # brightness / volume wiget
    ./hyprscrolling.nix
    #./hyprexpro.nix
    ./window_decorations.nix
    ./workspaces.nix
    
    ./default_apps.nix
  ] 
  ++ (if host != "iso" then [
      ./hyprlock.nix
    ] else []);

  home.packages = (with pkgs; [
    wl-clipboard                      # clipboard utils for wayland (wl-copy, wl-paste)
    pavucontrol                       # pulseaudio volume controle (GUI)
    swappy                            # snapshot editing tool
  ]);
}
