{ pkgs, ... }: 
let 
  toggle_blur = pkgs.writeShellScriptBin "toggle_blur" ''
#!/usr/bin/env bash

if hyprctl getoption decoration:blur:enabled | grep "int: 1" > /dev/null; then
    hyprctl keyword decoration:blur:enabled false > /dev/null
else
    hyprctl keyword decoration:blur:enabled true > /dev/null
fi
  '';

  toggle_float = pkgs.writeShellScriptBin "toggle_float" ''
#!/usr/bin/env bash

hyprctl dispatch togglefloating
hyprctl dispatch resizeactive exact 1111 700
hyprctl dispatch centerwindow
  '';

  toggle_oppacity = pkgs.writeShellScriptBin "toggle_oppacity" ''
#!/usr/bin/env bash

if hyprctl getoption decoration:active_opacity | grep "float: 1" > /dev/null; then
    hyprctl keyword decoration:active_opacity 0.90 > /dev/null
    hyprctl keyword decoration:inactive_opacity 0.90 > /dev/null
else
    hyprctl keyword decoration:active_opacity 1 > /dev/null
    hyprctl keyword decoration:inactive_opacity 1 > /dev/null
fi
  '';

  toggle_waybar = pkgs.writeShellScriptBin "toggle_waybar" ''
#!/usr/bin/env bash

SERVICE=".waybar-wrapped"

if pgrep -x "$SERVICE" > /dev/null; then
    pkill -9 waybar
else
    runbg waybar
fi
  '';

 in {
  home.packages = (with pkgs; [
    toggle_blur
    toggle_float
    toggle_oppacity
    toggle_waybar
  ]);
}
