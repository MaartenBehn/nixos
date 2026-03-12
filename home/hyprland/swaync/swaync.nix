{ pkgs, config, ... }:
let

  layout_actions =  builtins.map (name: {label = name; command = "set-layout ${name}";}) (builtins.attrNames config.layouts.layouts);

  swaync_config = {
    positionX = "right";
    positionY = "top";
    layer = "overlay";
    layer-shell = "true";
    cssPriority = "user";
    control-center-margin-top = 10;
    control-center-margin-bottom = 10;
    control-center-margin-right = 10;
    control-center-margin-left = 10;
    notification-icon-size = 64;
    notification-body-image-height = 128;
    notification-body-image-width = 200;
    timeout = 10;
    timeout-low = 5;
    timeout-critical = 0;
    fit-to-screen = true;
    control-center-width = 400;
    control-center-height = 650;
    notification-window-width = 350;
    keyboard-shortcuts = true;
    image-visibility = "when-available";
    transition-time = 200;
    hide-on-clear = false;
    hide-on-action = true;
    script-fail-notify = true;
    widgets = [
      "title"
      "menubar#desktop"
      "volume"
      "backlight#mobile"
      "mpris"
      "dnd"
      "notifications"
    ];
    widget-config = {
      title = {
        text = " Notifications";
        clear-all-button = true;
        button-text = " Clear All ";
      };
      "menubar#desktop" = {
        "menu#monitors" = {
          label = " 󰹑 ";
          position = "left";
          actions = layout_actions;     
        };
        "menu#powermode-buttons" = {
          label = " 󰌪 ";
          position = "left";
          actions = [
            {
              label = "Performance";
              command = "powerprofilesctl set performance";
            }
            {
              label = "Balanced";
              command = "powerprofilesctl set balanced";
            }
            {
              label = "Power-saver";
              command = "powerprofilesctl set power-saver";
            }
          ];
        };
        "menu#screenshot" = {
          label = " 󰩭 ";
          position = "left";
          actions = [
            {
              label = "󰹑  Whole screen";
              command = "grimblast --notify --cursor --freeze copy output";
            }
            {
              label = "󰩭  Window / Region";
              command = "grimblast --notify --cursor --freeze copy area";
            }
          ];
        };
        "menu#record" = {
          label = " 󰕧 ";
          position = "left";
          actions = [
            {
              label = "  Record screen";
              command = "record screen & ; swaync-client -t";
            }
            {
              label = "  Record selection";
              command = "record area & ; swaync-client -t";
            }
            {
              label = "  Record GIF";
              command = "record gif & ; swaync-client -t";
            }
            {
              label = "󰻃  Stop";
              command = "record stop";
            }
          ];
        };
        "menu#power-buttons" = {
          label = "  ";
          position = "left";
          actions = [
            {
              label = "  Lock";
              command = "hyprlock";
            }
            {
              label = "  Reboot";
              command = "systemctl reboot";
            }
            {
              label = "  Shut down";
              command = "systemctl poweroff";
            }
          ];
        };
      };
      "backlight#mobile" = {
        label = " 󰃠 ";
        device = "panel";
      };
      volume = {
        label = "";
        expand-button-label = "";
        collapse-button-label = "";
        show-per-app = true;
        show-per-app-icon = true;
        show-per-app-label = false;
      };
      dnd = {
        text = " Do Not Disturb";
      };
      mpris = {
        image-size = 85;
        image-radius = 5;
      };
    };
  };
  
  config_file = pkgs.writeText "config.json" (builtins.toJSON swaync_config);  
in {
  home.packages = (with pkgs; [ swaynotificationcenter ]);
  xdg.configFile."swaync/style.css".source = ./style.css;
  xdg.configFile."swaync/config.json".source = config_file;
}
