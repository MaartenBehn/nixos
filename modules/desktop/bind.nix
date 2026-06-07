{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland.settings = {
      bind = [
        # show keybinds list
        "$mainMod, F1, exec, show-keybinds"

        # keybindings
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, togglefloating"
        "$mainMod, T, exec, toggle_oppacity"

        # System shortcuts
        "$mainMod, Escape, exec, hyprlock"
        "$mainMod SHIFT, Escape, exec, power-menu"
        "$mainMod, D, exec, rofi -show drun || pkill rofi"
        "$mainMod SHIFT, B, exec, toggle_waybar"
        "$mainMod, W, exec, wallpaper-picker"
        "$mainMod, N, exec, swaync-client -t -sw"

        # Programm shortcuts
        "$mainMod, Space, exec, kitty -d $(hyprcwd)"
        "$mainMod, B, exec, firefox"
        "$mainMod, O, exec, obsidian"
        "$mainMod, E, exec, kitty -d $(hyprcwd) -e yazi"
        "$mainMod SHIFT, E, exec, nemo"
        "$mainMod, M, exec, thunderbird"
        "$mainMod SHIFT, V, exec, open_vim_cheat_sheet"

        # Other shortcuts
        "$mainMod, C, exec, hyprpicker -a"
        "$mainMod, Z, exec, woomer-current"

        # screenshot
        ",Print, exec, screenshot --copy"
        "$mainMod, Print, exec, screenshot --md-copy"


        # media and volume controls
        # ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop,exec, playerctl stop"

        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"

        # clipboard manager
        "$mainMod, V, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy"
      ];

      # # binds active in lockscreen
      # bindl = [
      #   # laptop brigthness
      #   ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
      #   ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
      #   "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
      #   "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
      # ];

      # # binds that repeat when held
      # binde = [
      #   ",XF86AudioRaiseVolume,exec, pamixer -i 2"
      #   ",XF86AudioLowerVolume,exec, pamixer -d 2"
      # ];

      # mouse binding
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

    };
  };
}
