{
  flake.modules.homeManager.hyprland = { pkgs, config, osConfig, lib, ... }:
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

        interface_names = builtins.attrNames osConfig.networking.wg-quick.interfaces;
        none_and_interface_names = ["none"] ++ interface_names;
        to_quoted_string = s: builtins.concatStringsSep " " (map (x: "\"${x}\"") s);
        interface_names_string = to_quoted_string interface_names;
        none_and_interface_names_string = to_quoted_string none_and_interface_names;

        vpn_status = pkgs.writeShellScriptBin "vpn_status" ''
          ACTIVE=""
          
          for iface in ${interface_names_string}; do
            if systemctl is-active --quiet "wg-quick-$iface.service"; then
              ACTIVE="$iface"
              break
            fi
          done

          if [ -z "$ACTIVE" ]; then
            echo '{"text": "󰦞 ", "alt": "off", "tooltip": "VPN: Disconnected", "class": "disconnected"}'
          else
            echo "{\"text\": \"$ACTIVE\", \"alt\": \"$ACTIVE\", \"tooltip\": \"VPN Active: $ACTIVE\", \"class\": \"connected\"}"
          fi
        '';
        vpn_cycle = pkgs.writeShellScriptBin "vpn_cycle" ''
          ACTIVE="none"

          for iface in ${interface_names_string}; do
            if systemctl is-active --quiet "wg-quick-$iface.service"; then
              ACTIVE="$iface"
              sudo systemctl stop "wg-quick-$iface.service"
              break
            fi
          done

          CYCLE_ORDER=( ${none_and_interface_names_string} )
          NEXT="none"
          for i in "''${!CYCLE_ORDER[@]}"; do
            if [[ "''${CYCLE_ORDER[$i]}" == "$ACTIVE" ]]; then
              NEXT_INDEX=$(( (i + 1) % ''${#CYCLE_ORDER[@]} ))
              NEXT="''${CYCLE_ORDER[$NEXT_INDEX]}"
              break
            fi
          done

          if [ "$NEXT" != "none" ]; then
            sudo systemctl start "wg-quick-$NEXT.service"
          fi
        '';
    in {
      home.packages = (with pkgs; [
        jq
        socat
        scrolling_output
        vpn_cycle
        vpn_status
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
          "pulseaudio"
          "battery"
          "custom/vpn"
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
          format = " {:%H:%M}";
          tooltip = "true";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = " {:%d/%m}";
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
        cpu = {
          format = "<span foreground='${green}'> </span> {usage}%";
          interval = 2;
          on-click = "hyprctl dispatch exec '${config.home.sessionVariables.terminal} -e btop'";
        };
        memory = {
          format = "<span foreground='${cyan}'> </span> {}%";
          interval = 2;
          on-click = "hyprctl dispatch exec '${config.home.sessionVariables.terminal} -e btop'";
        };
        disk = {
          # path = "/";
          format = "<span foreground='${orange}'>󰋊 </span> {percentage_used}%";
          interval = 60;
          on-click = "hyprctl dispatch exec '${config.home.sessionVariables.terminal} -e btop'";
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
        bluetooth = {
          format = "<span foreground='${blue}'>󰂯</span>";
          interval = 2;
          on-click = "hyprctl dispatch exec 'blueberry'";
        };
        "custom/vpn" = let
          colorMap = {
            "private" = green;
            "private_local" = cyan;
            "fritz_behns" = orange;
          };

          interfaces = builtins.attrNames osConfig.networking.wg-quick.interfaces;

          formatIcons = {
            "off" = "<span foreground='${border_color}'>󰦞</span>";
          } // (builtins.listToAttrs (map (name: {
              name = name;
              value = "<span foreground='${colorMap.${name} or yellow}'>󰖂</span>";
            }) interfaces));

          menuItems = [ "1) disconnect" ] ++ (lib.imap1 (i: name: "${toString (i + 1)}) ${name}") interfaces);
          menuText = builtins.concatStringsSep "\\n" menuItems;

          # Build shell case logic dynamically:
          # 1) for status check/stop all; 2..N) invoke the respective ${name}_vpn script
          caseBranches = [ "1) vpn_cycle ;; # (or use systemctl stop directly)" ] ++ (lib.imap1 (i: name: "${toString (i + 1)}) ${name}_vpn ;;") interfaces);
          caseText = builtins.concatStringsSep " " caseBranches;

        in {
          #exec = "vpn_status";
          return-type = "json";
          interval = 1;
          #on-click = "vpn_cycle";
          exec = "vpn_status 2>> /tmp/waybar_vpn.log";
          on-click = "vpn_cycle >> /tmp/waybar_vpn.log 2>&1";
          #on-click = "hyprctl dispatch exec '${config.home.sessionVariables.terminal} -e \"echo -e \\\"${menuText}\\\"; read -p \\\"Select interface: \\\" opt; case \\$opt in ${caseText} esac\"'";
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
          format = "<span foreground=\"#AF8ED6\">󰹑 </span> {}%";
          on-click = "hyprctl dispatch exec ${config.home.sessionVariables.terminal} -e nvtop'";
        };
      };
    };
}
