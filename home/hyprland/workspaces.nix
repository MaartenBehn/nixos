{ host, ... }: {
  wayland.windowManager.hyprland.settings = {

    bind = [
      # switch workspace
      "$mainMod, up, workspace, -1"
      "$mainMod, down, workspace, +1"
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"

      # same as above, but switch to the workspace
      "$mainMod SHIFT, left, movetoworkspacesilent, -1"
      "$mainMod SHIFT, right, movetoworkspacesilent, +1"
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
      "$mainMod CTRL, c, movetoworkspace, empty"
    ];

    workspace = (if host == "laptop" then [  
      "1, monitor:eDP-1, default:true" 
      "r[2-3], monitor:eDP-1"

      "4, monitor:DP-5, default:true"
      "r[5-6], monitor:DP-5"

      "4, monitor:DP-7, default:true"
      "r[5-6], monitor:DP-7"

      "7, monitor:DP-6, default:true"
      "r[8-9], monitor:DP-6"

      "7, monitor:DP-8, default:true"
      "r[8-9], monitor:DP-8"
    ]
    else if host == "desktop" then [ 
        "1, monitor:HDMI-A-1, default:true"
        "2, monitor:HDMI-A-1"
        "3, monitor:HDMI-A-1"

        "4, monitor:HDMI-A-2, default:true"
        "5, monitor:HDMI-A-2"
        "6, monitor:HDMI-A-2"
      ]
    else []);
  };
}
