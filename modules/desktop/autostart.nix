{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland.extraConfig = #lua
      ''
      hl.on("hyprland.start", function()
        -- environment for systemd and dbus services
        hl.exec_cmd("dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")

        -- needed to look fine
        hl.exec_cmd("guess-layout")
        hl.exec_cmd("waybar")
        hl.exec_cmd("awww-daemon")
        hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 24")

        -- rest (delayed)
        hl.exec_cmd("sleep 0.6 && nm-applet")
        hl.exec_cmd("sleep 0.6 && wl-clip-persist --clipboard both")
        hl.exec_cmd("sleep 0.6 && wl-paste --watch cliphist store")
        hl.exec_cmd("sleep 0.6 && swaync")
      end)
    '';
  };
}
