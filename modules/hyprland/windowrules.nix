{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.settings = {
      windowrule = [
        # System 
        "match:title ^(rofi)$, pin on"
        "match:title ^(waypaper)$, pin on, float on"

        # Task Bar Programms
        "match:class ^(nm-connection-editor)$, float on, move (monitor_w*0.4) (monitor_h*0.4)"

        "match:title ^(Mullvad VPN)$, move (monitor_w-window_w-10) (monitor_h-window_h-40)"

        "match:title ^(Bluetooth)$, float on"
        "match:title ^(Bluetooth)$, move (monitor_w-window_w-10) (monitor_h-window_h-40)"

        "match:class org.pulseaudio.pavucontrol, float on, size (monitor_w*0.4) (monitor_h*0.4), move (monitor_w-monitor_w*0.4-10) (monitor_h-monitor_h*0.4-40)"

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

        "match:title ^(Open File)$, float on, size <(monitor_w*0.9) <(monitor_h*0.9)"
        "match:title ^(File Upload)$, float on, size <(monitor_w*0.9) <(monitor_h*0.9)"

        "match:title ^(branchdialog)$, float on"
        "match:title ^(Confirm to replace files)$, float on"
        "match:title ^(File Operation Progress)$, float on"
        "match:title ^(Save As)$, float on" 

        # Remove context menu transparency in chromium based apps
        #"match:class ^()$, match:title ^()$, opaque on, no_shadow on, no_blur on"

        # Programms 
        "match:class ^(firefox)$, idle_inhibit always"
        "match:title ^(imv)$, float on"
        "match:title ^(.*imv.*)$, opacity 1.0 override 1.0 override"

        "match:title ^(mpv)$, float on, idle_inhibit always"
        "match:title ^(.*mpv.*)$, opacity 1.0 override 1.0 override"

        "match:title ^(Aseprite)$, tile on, opacity 1.0 override 1.0 override"

        "match:class ^(Unity)$, opacity 1.0 override 1.0 override, idle_inhibit always"

        "match:class ^(blender)$, float off"

        # Other ?
        "match:title ^(audacious)$, float on"

        "match:title ^(Viewnior)$, float on" 
        "match:title ^(neovide)$, tile on"
        "match:title ^(udiskie)$, float on"

        #"float,class:^(zenity)$"
        #"size 850 500,class:^(zenity)$"
        #"size 725 330,class:^(SoundWireServer)$"
        #"float,class:^(org.gnome.FileRoller)$"
        #"float,class:^(SoundWireServer)$"
        #"float,class:^(.sameboy-wrapped)$"  
      ];

      extraConfig = " 
        xwayland {
          force_zero_scaling = true
        }
      ";
    };
  };
}
