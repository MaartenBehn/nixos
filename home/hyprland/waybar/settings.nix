{ terminal, pkgs, ... }:
let
  custom = {
    font = "JetBrains Mono";
    font_size = "18px";
    font_weight = "bold";
    text_color = "#FBF1C7";
    background_0 = "#1D2021";
    background_1 = "#282828";
    border_color = "#928374";
    red = "#CC241D";
    green = "#98971A";
    yellow = "#FABD2F";
    blue = "#458588";
    magenta = "#B16286";
    cyan = "#689D6A";
    orange = "#D65D0E";
    opacity = "1";
    indicator_height = "2px";
  };

  scrolling_output = pkgs.writeShellScriptBin "scrolling_output" ''
    trigger() {
      ACTIVE_WORKSPACE="$(hyprctl monitors -j | jq --arg WAYBAR_OUTPUT_NAME "$WAYBAR_OUTPUT_NAME" '.[] | select(.name == $WAYBAR_OUTPUT_NAME) | .activeWorkspace.id')"
      ACTIVE_WINDOW="$(hyprctl workspaces -j | jq -j --arg ACTIVE_WORKSPACE "$ACTIVE_WORKSPACE" '.[] | select(.id == ($ACTIVE_WORKSPACE | tonumber)) | .lastwindow')"
      hyprctl clients -j | jq -j --arg ACTIVE_WORKSPACE "$ACTIVE_WORKSPACE" --arg ACTIVE_WINDOW "$ACTIVE_WINDOW" '[ .[] | select(.workspace.id == ($ACTIVE_WORKSPACE | tonumber)) ] 
        | group_by(.at.[0]) 
        | [.[] | {
            at: .[0].at.[0], 
            titles: [.[] | (if .title | length > 12 then .title[:9] + "..." else .title end)], 
            active: any(.; .[].address == $ACTIVE_WINDOW) 
          }] 
        | sort_by(.at)[] 
        | "<span" 
          + (if .active then " foreground=\"#FE8019\"" else "" end)
          + "> "
          + (if .titles | length > 1 then "[" else "" end) 
          + ( .titles | join(" ")) 
          + (if .titles | length > 1 then "]" else "" end) 
          + " </span>"'    
      echo ""
    }

    handle() {
      case $1 in
        activewindow*) trigger ;;
        workspace*) trigger ;;
        movewindow*) trigger ;;
      esac
    }

    socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | while read -r line; do handle "$line"; done
  '';

  gpu_usage = pkgs.writeShellScriptBin "gpu_usage" ''
    nvtop -s | jq -r '[
      (.[0].gpu_util 
        | if . != null then (. 
          | rtrimstr("%") 
          | tonumber
        ) else null end), 
      (.[0].gpu_clock 
        | if . != null then (. 
          | rtrimstr("MHz") 
          | tonumber 
          | (. / 1500) * 100
        ) else null end)] 
      | .[] 
      | select(. != null) 
      | round' | head -n 1; 
  '';

in {
  home.packages = (with pkgs; [
    jq
    socat
    scrolling_output
  ]);

  programs.waybar.settings.mainBar = with custom; {
    #output = (if host == "laptop" then [ "eDP-1" "DP-5" "DP-6" "DP-7" "DP-8" "DP-9" "DP-10" "DP-11" ] else [ "all" ]);
    position = "bottom";
    layer = "top";
    height = 28;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "custom/tmux"
      "custom/scrolling"
    ];
    modules-center = [ ];
    modules-right = [
      "cpu"
      "memory"
      "custom/gpu"
      #(if (host == "desktop") then "disk" else "")
      "pulseaudio"
      "battery"
      "bluetooth"
      "tray"
      "clock"
      "custom/notification"
    ];
    clock = {
      calendar = {
        format = {
          today = "<span color='#98971A'><b>{}</b></span>";
        };
      };
      format = "  {:%H:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "  {:%d/%m}";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        sort-by-number = true;
      };
      persistent-workspaces = {
      };
    };
    bluetooth = {
      format = "<span foreground='${blue}'>󰂯</span>";
      interval = 2;
      on-click = "hyprctl dispatch exec 'blueberry'";
    };

    cpu = {
      format = "<span foreground='${green}'> </span> {usage}%";
      interval = 2;
      on-click = "hyprctl dispatch exec '${terminal} -e btop'";
    };
    memory = {
      format = "<span foreground='${cyan}'> </span>{}%";
      interval = 2;
      on-click = "hyprctl dispatch exec '${terminal} -e btop'";
    };
    disk = {
      # path = "/";
      format = "<span foreground='${orange}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click = "hyprctl dispatch exec '${terminal} -e btop'";
    };
    network = {
      format-wifi = "<span foreground='${magenta}'> </span> {signalStrength}%";
      format-ethernet = "<span foreground='${magenta}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "<span foreground='${magenta}'>󰖪 </span>";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='${blue}'> </span> {volume}%";
      format-icons = {
        default = [ "<span foreground='${blue}'> </span>" ];
      };
      scroll-step = 2;
      max-volume = 150;
      on-click = "pavucontrol";
    };
    battery = {
      format = "<span foreground='${yellow}'>{icon}</span> {capacity}%";
      format-icons = [
        " "
        " "
        " "
        " "
        " "
      ];
      format-charging = "<span foreground='${yellow}'> </span>{capacity}%";
      format-full = "<span foreground='${yellow}'> </span>{capacity}%";
      format-warning = "<span foreground='${yellow}'> </span>{capacity}%";
      interval = 5;
      states = {
        warning = 20;
      };
      format-time = "{H}h{M}m";
      tooltip = true;
      tooltip-format = "{time}";
    };
    "custom/launcher" = {
      format = "";
      on-click = "rofi -show drun";
    };
    "custom/notification" = {
      tooltip = false;
      format = "{icon} ";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span> <span foreground='${red}'></span>";
        none = "  <span foreground='${red}'></span>";
        dnd-notification = "<span foreground='red'><sup></sup></span> <span foreground='${red}'></span>";
        dnd-none = "  <span foreground='${red}'></span>";
        inhibited-notification = "<span foreground='red'><sup></sup></span> <span foreground='${red}'></span>";
        inhibited-none = "  <span foreground='${red}'></span>";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span> <span foreground='${red}'></span>";
        dnd-inhibited-none = "  <span foreground='${red}'></span>";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
    "custom/tmux" = {
      exec = "tmux lsw -F '#{?window_active,[, }#{window_name}#{?window_bell_flag,!,}#{?window_active,], }' | tr -d '\n@'";
      signal = 8;
    };
    "custom/scrolling" = {
      exec = "${scrolling_output}/bin/scrolling_output";
    };
    "custom/gpu" = {
      exec = "${gpu_usage}/bin/gpu_usage";
      interval = 5;
      format = "<span foreground=\"#AF8ED6\">󰹑 </span>{}%";
      on-click = "hyprctl dispatch exec '${terminal} -e nvtop'";
    };
  };
}
