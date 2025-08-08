{ inputs, pkgs, ... }: {
  wayland.windowManager.hyprland.plugins = [
    inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}.hyprexpo
  ];

  wayland.windowManager.hyprland.settings = {
    # https://github.com/hyprwm/hyprland-plugins/tree/main/hyprexpo
    plugin.hyprexpo = {
      columns = 3;
      gap_size = 5;
      bg_col = "rgb(111111)";
      workspace_method = "first 1"; # [center/first] [workspace] e.g. first 1 or center m+1
      skip_empty = false;

      enable_gesture = true; # laptop touchpad
      gesture_fingers = 3;  # 3 or 4
      gesture_distance = 300; # how far is the "max"
      gesture_positive = true; # positive = swipe down. Negative = swipe up.
    };

    bind = [
      "$mainMod, tab, hyprexpo:expo, toggle"
    ];
  };
}
