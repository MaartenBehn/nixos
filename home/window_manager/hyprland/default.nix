{ desktop, ... }:
{
  imports = if desktop == "hyprland" then [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./variables.nix
    ./swaync/swaync.nix
    ./waybar
    ./waypaper.nix
    ./xdg-mimes.nix
    ./rofi.nix
    #inputs.hyprland.homeManagerModules.default
  ] else [];
}
