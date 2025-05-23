{ pkgs, host, ... }:
{
  imports = [
    ./hyprland.nix
    ./config.nix
    ./variables.nix
    
    # Needed parts
    ./swaync/swaync.nix
    ./waybar
    ./waypaper.nix
    ./xdg-mimes.nix
    ./gtk.nix
    ./rofi.nix
    ./swayosd.nix                     # brightness / volume wiget
    ./pix2tex.nix
    
    #inputs.hyprland.homeManagerModules.default
  ] 
  ++ (if host != "iso" then [
      ./hyprlock.nix
    ] else []);

  home.packages = (with pkgs; [
    wl-clipboard                      # clipboard utils for wayland (wl-copy, wl-paste)
    woomer
    pavucontrol                       # pulseaudio volume controle (GUI)
    swappy                            # snapshot editing tool
  ]);
}
