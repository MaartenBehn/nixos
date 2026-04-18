{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland.plugins = [
    pkgs.hyprlandPlugins.hyprscrolling
  ];

  wayland.windowManager.hyprland.settings = {
    general.layout = "scrolling";

    scrolling = {
      fullscreen_on_one_column = true;
      column_width = 1.0;
      explicit_column_widths = "0.25, 0.5, 1.0";
      focus_fit_method = 1;
      follow_focus = true;
    };

    bind = [
      # move focus
      "$mainMod, right, layoutmsg, focus r"
      "$mainMod, left, layoutmsg, focus l"

      # window control
      "$mainMod ALT, left, layoutmsg, swapcol l"
      "$mainMod ALT, right, layoutmsg, swapcol r"
      #"$mainMod ALT, up, layoutmsg, movewindowto up"
      #"$mainMod ALT, down, layoutmsg, movewindowto down"

      "$mainMod CTRL, left, layoutmsg, colresize -conf"
      "$mainMod CTRL, right, layoutmsg, colresize +conf"
      #"$mainMod CTRL, up, resizeactive, 0 -80"
      #"$mainMod CTRL, down, resizeactive, 0 80"
    ];
  };
}
