{ pkgs, lib, host, config, ... }:
let

  layout_names = builtins.attrNames config.layouts.layouts;
  layout_names_text = lib.strings.concatStringsSep ", " layout_names;

  get_layout = n: config.layouts.layouts."${n}";
  monitor_commands = n: lib.strings.concatLines (builtins.map (m: "hyprctl keyword monitor ${m}") (get_layout n).monitors);
  workspace_commands = n: lib.strings.concatLines (builtins.map (w: "hyprctl keyword workspace ${w}") (get_layout n).workspaces);
  extra_command = n: (get_layout n).command;
  extra_post_command = n: (get_layout n).post_command;

  if_statments = lib.strings.concatLines (builtins.map (n: ''
    if [ "$1" == "${n}" ]; then 
    ${extra_command n}
    ${monitor_commands n}
    ${workspace_commands n}
    ${extra_post_command n}
    fi
    '') layout_names);

  set-monitors = pkgs.writeShellScriptBin "set-monitors" ''
    if [ $# -eq 0 ]; then
      echo "No arg of: ${layout_names_text}"
      exit
    fi

    ${if_statments}
    '';

  set-monitors-present = pkgs.writeShellScriptBin "set-monitors-present" ''
    if [ $# -eq 0 ]; then
      echo "Must give main monitor as arg"
      exit
    fi

    other=$(hyprctl monitors all -j | jq -r --arg main "$1" '[.[].name] | map(select(. != $main)) | first')
    echo "Selcted present monitor: $other"

    hyprctl keyword monitor $other,highres,auto,1
    hyprctl keyword monitor $1,highres,auto,1,mirror,$other

    hyprctl keyword workspace 1, monitor:$1, default:true
    hyprctl keyword workspace r[2-15], monitor:$1
  '';

  disable-other-monitors = pkgs.writeShellScriptBin "disable-other-monitors" ''
    if [ $# -eq 0 ]; then
      echo "Must give main monitor as arg"
      exit
    fi

    other=$(hyprctl monitors all -j | jq -r --arg main "$1" '[.[].name] | map(select(. != $main)) | .[]')

    while IFS= read -r line; do
      echo "Disabling: $line"
      hyprctl keyword monitor $line,disable
    done <<< "$other"
  '';

  set-other-monitors-auto = pkgs.writeShellScriptBin "set-other-monitors-auto" ''
    if [ $# -eq 0 ]; then
      echo "Must give main monitor as arg"
      exit
    fi

    other=$(hyprctl monitors all -j | jq -r --arg main "$1" '[.[].name] | map(select(. != $main)) | .[]')

    while IFS= read -r line; do
      echo "Auto: $line"
      hyprctl keyword monitor $line,highres,auto,1
    done <<< "$other"
  '';

  current-layout = pkgs.writeShellScriptBin "current-layout" ''
    mkdir -p ~/.config/layout/
    cd ~/.config/layout/
    if [ ! -f "current_layout" ]; then
      echo "${config.layouts.initial}"
    else 
      cat current_layout
    fi
  '';

  set-layout = pkgs.writeShellScriptBin "set-layout" ''
    if [ $# -eq 0 ]; then
      echo "No layout arg"
      exit
    fi

    set-monitors $1
    sleep 2

    wallpaper="$(wallpaper-for-layout $1)"
    set-wallpaper $wallpaper

    mkdir -p ~/.config/layout/
    cd ~/.config/layout/
    echo "$1" > "current_layout"
  '';
 
  restore-layout = pkgs.writeShellScriptBin "restore-layout" ''
    layout="$(current-layout)"
    set-monitors $layout
    
    wallpaper="$(wallpaper-for-layout $layout)"
    set-wallpaper $wallpaper
  '';

  guess-layout = pkgs.writeShellScriptBin "guess-layout" ''
    #network="$(nmcli -c no)"

    #if [[ $network == *"DLR Gastzugang"* ]]; then
    #  set-layout "dlr"
    #  exit
    #fi

    set-layout "${config.layouts.initial}"
  '';
  
  initial_layout = get_layout config.layouts.initial;
in {
  options = {
    layouts = lib.mkOption {
      type = lib.types.submodule {
        options = {

          layouts = lib.mkOption {
            type = lib.types.attrsOf (lib.types.submodule {
              options = {
                monitors = lib.mkOption {
                  type = lib.types.listOf(lib.types.str);
                  description = "Monitor Settings";
                  default = [];
                };

                workspaces = lib.mkOption {
                  type = lib.types.listOf(lib.types.str);
                  description = "Monitor Workspace Settings";
                  default = [];
                };

                command = lib.mkOption {
                  type = lib.types.str;
                  description = "Command to run when swicting to layout";
                  default = "";
                };

                post_command = lib.mkOption {
                  type = lib.types.str;
                  description = "Command to run when swicting to layout";
                  default = "";
                };
              };
            });
          };

          initial = lib.mkOption {
            type = lib.types.str;
            description = "Default layout";
            default = "home";
          };
        };
      };
    };
  };

  config = {
    layouts = if host == "laptop" then {
      initial = "home";

      layouts = {
        none = {
          monitors = [
            "eDP-1,2256x1504,0x0,1"
          ];

          workspaces = [
            "1, monitor:eDP-1, default:true" 
            "r[2-15], monitor:eDP-1"
          ];
          
          post_command = "disable-other-monitors eDP-1";
        };

        extend = {
          monitors = [
            "eDP-1,2256x1504,0x0,1"
            ",highres,auto,1"
          ];

          workspaces = [
            "1, monitor:eDP-1, default:true" 
          ];
          
          post_command = "set-other-monitors-auto eDP-1";
        }; 

        home = {
          monitors = [
            "eDP-1,2256x1504,0x0,1"
            "DP-5,1920x1080,-1920x0,1"
            "DP-6,1920x1080,-3840x0,1"
            "DP-7,1920x1080,-1920x0,1"
            "DP-8,1920x1080,-3840x0,1"
          ];

          workspaces = [
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
          ];
        };

        mirror = {
          monitors = [
            "eDP-1,2256x1504,0x0,1"
            "DP-1,highres,auto,1,mirror,eDP-1"
            "DP-2,highres,auto,1,mirror,eDP-1"
            "DP-3,highres,auto,1,mirror,eDP-1"
            "DP-4,highres,auto,1,mirror,eDP-1"
            "DP-5,highres,auto,1,mirror,eDP-1"
            "DP-6,highres,auto,1,mirror,eDP-1"
            "DP-7,highres,auto,1,mirror,eDP-1"
            "DP-8,highres,auto,1,mirror,eDP-1"
            "DP-9,highres,auto,1,mirror,eDP-1"
            "DP-10,highres,auto,1,mirror,eDP-1"
            "DP-11,highres,auto,1,mirror,eDP-1"
          ];

          workspaces = [
            "1, monitor:eDP-1, default:true "
            "r[2-15], monitor:eDP-1"
          ];
        };

        present = {
          command = "set-monitors-present eDP-1";
        };
      };
    } else {
      initial = "home";
      
      layouts = {
        home = {
          monitors = [
            "HDMI-A-1,1920x1080,0x0,1"
            "HDMI-A-2,1920x1080,1920x0,1"
          ];

          workspaces = [
            "1, monitor:HDMI-A-1, default:true"
            "2, monitor:HDMI-A-1"
            "3, monitor:HDMI-A-1"

            "4, monitor:HDMI-A-2, default:true"
            "5, monitor:HDMI-A-2"
            "6, monitor:HDMI-A-2"
          ];
        };
      };
    };

    wayland.windowManager.hyprland.settings = {
      workspace = initial_layout.workspaces;
      monitor = initial_layout.monitors;
    };

    home.packages = [ 
      current-layout
      set-layout
      set-monitors
      set-monitors-present
      disable-other-monitors
      set-other-monitors-auto
      restore-layout
      guess-layout
    ];
  };
}
