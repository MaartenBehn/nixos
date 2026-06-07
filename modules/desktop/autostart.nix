{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland.settings.exec-once = [
      "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"

      # Needed to look fine
      "guess-layout"
      "waybar"
      "swww-daemon"
      "hyprctl setcursor Bibata-Modern-Ice 24"

      # Rest
      "sleep 0.6 && nm-applet"
      "sleep 0.6 && wl-clip-persist --clipboard both"
      "sleep 0.6 && wl-paste --watch cliphist store"
      "sleep 0.6 && swaync"
    ];
  };
}
