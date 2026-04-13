{ host, terminal, ... }: {
  wayland.windowManager.hyprland = {
    settings = {
      # autostart
      exec-once = [
        "dbus-update-activation-environment --all --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
        "systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
         
        # Needed to look fine
        "guess-layout &"
        "waybar &"
        "swww-daemon &"
        "hyprctl setcursor Bibata-Modern-Ice 24 &"
       
        # Rest
        "sleep 0.6 && nm-applet &"
        "sleep 0.6 && poweralertd -s -i 'line power' &"
        "sleep 0.6 && wl-clip-persist --clipboard both &"
        "sleep 0.6 && wl-paste --watch cliphist store &"
        "sleep 0.6 && swaync &"

        #(if host != "iso" then "hyprlock" else "")
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
        #new_window_takes_over_fullscreen = 2;
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
        "$mainMod, E, exec, nemo"
        "$mainMod SHIFT, E, exec, hyprctl dispatch exec '[float; size 1111 700] ${terminal} -e yazi'"
        "$mainMod, M, exec, thunderbird"
        "$mainMod SHIFT, V, exec, open_vim_cheat_sheet"
        
        # Other shortcuts
        "$mainMod, C, exec, hyprpicker -a"
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
        # System 
        "match:title ^(rofi)$, pin on"
        "match:title ^(waypaper)$, pin on, float on"

        # Task Bar Programms
        "match:class ^(nm-connection-editor)$, float on, move 100%-w-10 100%-w-40"

        "match:title ^(Mullvad VPN)$, move 100%-w-10 100%-w-40"
        
        "match:title ^(Bluetooth)$, float on"
        "match:title ^(Bluetooth)$, move 100%-w-10 100%-w-40"

        "match:class ^(org.pulseaudio.pavucontrol)$, float on, move 100%-w-10 100%-w-40"

        "${if host == "laptop" then "match:title ^(Volume Control)$, size 40% 40%" else "match:title ^(Volume Control)$, size 60% 60%"}"

        # Overlays
        "match:title ^(Picture-in-Picture)$, float on, opacity 1.0 override 1.0 override, pin on"
        "match:title ^(Firefox — Sharing Indicator)$, float on, move 0 0"

        # Sharing popup
        "match:title ^(Select what to share)$, float on"
        "match:class ^(xwaylandvideobridge)$, opacity 0.0 override, no_anim on, no_initial_focus on, max_size 1 1, no_blur on"

        # Bitwarden Popup
        # "float, title:(.*)(Bitwarden)(.*)"
        # Not possible as the inital Window is Firefox

        # File Popups
        "match:class ^(file_progress)$, float on"
        "match:class ^(confirm)$, float on"
        "match:class ^(dialog)$, float on"
        "match:class ^(download)$, float on"
        "match:class ^(notification)$, float on"
        "match:class ^(error)$, float on"
        "match:class ^(confirmreset)$, float on"

        "match:title ^(Open File)$, float on, size <90% <90%"
        "match:title ^(File Upload)$, float on, size <90% <90%"
        
        "match:title ^(branchdialog)$, float on"
        "match:title ^(Confirm to replace files)$, float on"
        "match:title ^(File Operation Progress)$, float on"
        "match:title ^(Save As)$, float on" 

        # Remove context menu transparency in chromium based apps
        "match:class ^()$, match:title ^()$, opaque on, no_shadow on, no_blur on"

        # Programms 
        "match:title ^(imv)$, float on"
        "match:title ^(.*imv.*)$, opacity 1.0 override 1.0 override"

        "match:title ^(mpv)$, float on, idle_inhibit on"
        "match:title ^(.*mpv.*)$, opacity 1.0 override 1.0 override"

        "match:title ^(Aseprite)$, tile on, opacity 1.0 override 1.0 override"

        "match:class (Unity), opacity 1.0 override 1.0 override"

        # Other ?
        "match:title ^(audacious)$, float on"

        "match:title ^(Viewnior)$, float on" 
        "match:title ^(neovide)$, tile on"
        "match:title ^(udiskie)$, float on"
 
        "match:class ^(firefox)$, idle_inhibit on, fullscreen on"
        
        #"float,class:^(zenity)$"
        #"size 850 500,class:^(zenity)$"
        #"size 725 330,class:^(SoundWireServer)$"
        #"float,class:^(org.gnome.FileRoller)$"
        #"float,class:^(SoundWireServer)$"
        #"float,class:^(.sameboy-wrapped)$"  
      ];
    };

    extraConfig = " 
      xwayland {
        force_zero_scaling = true
      }
    ";
  };
}
