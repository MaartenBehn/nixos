{ host, terminal, ... }: {
  wayland.windowManager.hyprland = {
    settings = {
      # autostart
      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        # load all plugins
        "hyprctl plugin load \"$HYPR_PLUGIN_DIR/lib/libhyprexpo.so\""
        
        "nm-applet &"
        "poweralertd -s &"
        "wl-clip-persist --clipboard both &"
        "wl-paste --watch cliphist store &"
        "waybar &"
        "swaync &"
        "hyprctl setcursor Bibata-Modern-Ice 24 &"
        "swww-daemon &"

        (if host != "iso" then "hyprlock" else "echo done")
      ];

      input = {
        kb_layout = "de";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        repeat_delay = 300;
        follow_mouse = 0;
        float_switch_override_focus = 0;
        mouse_refocus = 0;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        "$mainMod" = "SUPER";
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
        new_window_takes_over_fullscreen = 2;
        middle_click_paste = false;
        enable_anr_dialog = false;
      };

      binds = {
        movefocus_cycles_fullscreen = true;
      };

      bind = [
        # show keybinds list
        "$mainMod, F1, exec, show-keybinds"

        # keybindings
        "$mainMod, Space, exec, kitty -d $(hyprcwd)"
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, B, exec, firefox"
        "$mainMod, O, exec, obsidian"
        "$mainMod, D, exec, rofi -show drun || pkill rofi"
        "$mainMod SHIFT, D, exec, webcord --enable-features=UseOzonePlatform --ozone-platform=wayland"
        "$mainMod SHIFT, S, exec, hyprctl dispatch exec '[workspace 5 silent] SoundWireServer'"
        "$mainMod, Escape, exec, hyprlock"
        "$mainMod SHIFT, Escape, exec, power-menu"
        "$mainMod, P, pseudo,"
        "$mainMod, X, togglesplit,"
        "$mainMod, T, exec, toggle_oppacity"
        "$mainMod, E, exec, nemo"
        "$mainMod, M, exec, thunderbird"
        "$mainMod SHIFT, V, exec, open_vim_cheat_sheet"
        "ALT, E, exec, hyprctl dispatch exec '[float; size 1111 700] nemo'"
        "$mainMod SHIFT, E, exec, hyprctl dispatch exec '[float; size 1111 700] ${terminal} -e yazi'"
        "$mainMod SHIFT, B, exec, toggle_waybar"
        "$mainMod, C, exec, hyprpicker -a"
        "$mainMod, W, exec, hyprctl dispatch exec '[float; size 925 615] waypaper'"
        "$mainMod, N, exec, swaync-client -t -sw"
        "$mainMod, Z, exec, woomer-current"
        
        # screenshot
        ",Print, exec, screenshot --copy"
        "$mainMod, Print, exec, screenshot --md-copy"

        "$mainMod, right, layoutmsg, focus r"
        "$mainMod, left, layoutmsg, focus l"

         
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
 
      # windowrule
      windowrule = [
        "float,title:^(Viewnior)$"
        "float,title:^(imv)$"
        "float,title:^(mpv)$"
        "tile,title:^(Aseprite)$"
        "float,title:^(audacious)$"
        "pin,title:^(rofi)$"
        "pin,title:^(waypaper)$"
        "tile,title:^(neovide)$"
        "idleinhibit focus,title:^(mpv)$"
        "float,title:^(udiskie)$"
        "float,title:^(Transmission)$"

        "float,title:^(Firefox — Sharing Indicator)$"
        "move 0 0,title:^(Firefox — Sharing Indicator)$"
        
        "float,title:^(Volume Control)$"
        "${if host == "laptop" then "size 40% 40%,title:^(Volume Control)$" else "size 60% 60%,title:^(Volume Control)$"}"
        "${if host == "laptop" then "move 55% 55%,title:^(Volume Control)$" else "move 35% 35%,title:^(Volume Control)$"}"
       
        "move 100%-w-10 100%-w-40,title:^(Mullvad VPN)$"

        "float,title:^(Bluetooth)"
        "move 100%-w-10 100%-w-40,title:^(Bluetooth)$"

        "float, title:^(Picture-in-Picture)$"
        "opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$"
        "pin, title:^(Picture-in-Picture)$"
        
        "opacity 1.0 override 1.0 override, title:^(.*imv.*)$"
        "opacity 1.0 override 1.0 override, title:^(.*mpv.*)$"
        "opacity 1.0 override 1.0 override, class:(Aseprite)"
        "opacity 1.0 override 1.0 override, class:(Unity)"
        "opacity 1.0 override 1.0 override, class:(zen)"
        "opacity 1.0 override 1.0 override, class:(evince)"
        "idleinhibit focus, class:^(mpv)$"
        "idleinhibit fullscreen, class:^(firefox)$"
        #"float,class:^(org.gnome.Calculator)$"
        "float,class:^(waypaper)$"
        "float,class:^(zenity)$"
        "size 850 500,class:^(zenity)$"
        "size 725 330,class:^(SoundWireServer)$"
        "float,class:^(org.gnome.FileRoller)$"
        "float,class:^(org.pulseaudio.pavucontrol)$"
        "float,class:^(SoundWireServer)$"
        "float,class:^(.sameboy-wrapped)$"
        "float,class:^(file_progress)$"
        "float,class:^(confirm)$"
        "float,class:^(dialog)$"
        "float,class:^(download)$"
        "float,class:^(notification)$"
        "float,class:^(error)$"
        "float,class:^(confirmreset)$"
        "float,title:^(Open File)$"
        "float,title:^(File Upload)$"
        "float,title:^(branchdialog)$"
        "float,title:^(Confirm to replace files)$"
        "float,title:^(File Operation Progress)$"
        "float,title:^(Save As)$"

        "opacity 0.0 override,class:^(xwaylandvideobridge)$"
        "noanim,class:^(xwaylandvideobridge)$"
        "noinitialfocus,class:^(xwaylandvideobridge)$"
        "maxsize 1 1,class:^(xwaylandvideobridge)$"
        "noblur,class:^(xwaylandvideobridge)$"
 
        # Remove context menu transparency in chromium based apps
        "opaque,class:^()$,title:^()$"
        "noshadow,class:^()$,title:^()$"
        "noblur,class:^()$,title:^()$"
      ];
    };

    extraConfig = "
      ${if host == "laptop" then "
        monitor=eDP-1,2256x1504,0x0,1

        monitor=DP-5,1920x1080,-1920x0,1
        monitor=DP-6,1920x1080,-3840x0,1
        monitor=DP-7,1920x1080,-1920x0,1
        monitor=DP-8,1920x1080,-3840x0,1

        monitor=DP-3,highres,auto,1,mirror,eDP-1
 
      " else (if host == "desktop" then "
        monitor=HDMI-A-1,1920x1080,0x0,1
        monitor=HDMI-A-2,1920x1080,1920x0,1
      "else "
        monitor=,preferred,auto,1
      ")}

      xwayland {
        force_zero_scaling = true
      }
    ";
  };
}
