{
  flake.modules.homeManager.hyprland = { pkgs, lib, config, ... }:
    let
      layout_names = builtins.attrNames config.layouts.layouts;
      layout_names_text = lib.strings.concatStringsSep ", " layout_names;
      get_layout = n: config.layouts.layouts."${n}";

      # ---------- Lua generation ----------
      monitor_lua = m:
        if m.disabled then
          ''hl.monitor({ output = "${m.output}", disabled = true })''
        else
          ''hl.monitor({ output = "${m.output}", mode = "${m.mode}", position = "${m.position}", scale = ${toString m.scale}${lib.optionalString (m.mirror != null) '', mirror = "${m.mirror}"''} })'';

      workspace_lua = w:
        ''hl.workspace_rule({ workspace = "${w.workspace}"${lib.optionalString (w.monitor != null) '', monitor = "${w.monitor}"''}${lib.optionalString w.default '', default = true''} })'';

      layout_lua = n:
        let l = get_layout n; in
        lib.strings.concatStringsSep "\n"
          ((builtins.map monitor_lua l.monitors) ++ (builtins.map workspace_lua l.workspaces));

      # ---------- scripts ----------
      extra_command = n: (get_layout n).command;
      leave_command = n: (get_layout n).leave_command;

      if_statments = lib.strings.concatLines (builtins.map (n: ''
        if [ "$1" == "${n}" ]; then
          hyprctl eval '${layout_lua n}'
          ${extra_command n}
        fi
      '') layout_names);

      levae_if_statments = lib.strings.concatLines (builtins.map (n:
        if (leave_command n) != "" then ''
          if [ "$layout" == "${n}" ]; then
            ${leave_command n}
          fi
        '' else "") layout_names);

      set-monitors = pkgs.writeShellScriptBin "set-monitors" ''
        if [ $# -eq 0 ]; then
          echo "No arg of: ${layout_names_text}"
          exit
        fi

        layout=$(current-layout)
        ${levae_if_statments}

        ${if_statments}
      '';

      set-monitors-present = pkgs.writeShellScriptBin "set-monitors-present" ''
        if [ $# -eq 0 ]; then
          echo "Must give main monitor as arg"
          exit
        fi

        other=$(hyprctl monitors all -j | jq -r --arg main "$1" '[.[].name] | map(select(. != $main)) | .[]')
        first=$(printf "%s\n" "$other" | head -n 1)
        tail=$(printf "%s\n" "$other" | tail -n +2)
        echo "Selcted present monitor: $first"

        hyprctl eval "hl.monitor({ output = \"$first\", mode = \"highres\", position = \"auto\", scale = 1 })"
        hyprctl eval "hl.monitor({ output = \"$1\", mode = \"highres\", position = \"auto\", scale = 1, mirror = \"$first\" })"

        while IFS= read -r line; do
          [ -z "$line" ] && continue
          echo "Also mirroring: $line"
          hyprctl eval "hl.monitor({ output = \"$line\", mode = \"highres\", position = \"auto\", scale = 1, mirror = \"$first\" })"
        done <<< "$tail"
      '';

      disable-other-monitors = pkgs.writeShellScriptBin "disable-other-monitors" ''
        if [ $# -eq 0 ]; then
          echo "Must give main monitor as arg"
          exit
        fi

        other=$(hyprctl monitors all -j | jq -r --arg main "$1" '[.[].name] | map(select(. != $main)) | .[]')

        while IFS= read -r line; do
          [ -z "$line" ] && continue
          echo "Disabling: $line"
          hyprctl eval "hl.monitor({ output = \"$line\", disabled = true })"
        done <<< "$other"
      '';

      disable-all-monitors = pkgs.writeShellScriptBin "disable-all-monitors" ''
        monitors=$(hyprctl monitors all -j | jq -r '.[].name')

        while IFS= read -r line; do
          [ -z "$line" ] && continue
          echo "Disabling: $line"
          hyprctl eval "hl.monitor({ output = \"$line\", disabled = true })"
        done <<< "$monitors"
      '';

      set-other-monitors-auto = pkgs.writeShellScriptBin "set-other-monitors-auto" ''
        if [ $# -eq 0 ]; then
          echo "Must give main monitor as arg"
          exit
        fi

        other=$(hyprctl monitors all -j | jq -r --arg main "$1" '[.[].name] | map(select(. != $main)) | .[]')

        while IFS= read -r line; do
          [ -z "$line" ] && continue
          echo "Auto: $line"
          hyprctl eval "hl.monitor({ output = \"$line\", mode = \"highres\", position = \"auto\", scale = 1 })"
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

      guess-layout = pkgs.writeShellScriptBin "guess-layout" ''
        l=$(current-layout)

        if [[ $l != "extend" ]]; then
          set-layout $l
          exit
        fi

        set-layout "home"
      '';

      # ---------- option types ----------
      monitorType = lib.types.submodule {
        options = {
          output = lib.mkOption {
            type = lib.types.str;
            description = "Output name (empty string matches any monitor)";
          };
          mode = lib.mkOption { type = lib.types.str; default = "highres"; };
          position = lib.mkOption { type = lib.types.str; default = "auto"; };
          scale = lib.mkOption { type = lib.types.number; default = 1; };
          mirror = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
          disabled = lib.mkOption { type = lib.types.bool; default = false; };
        };
      };

      workspaceType = lib.types.submodule {
        options = {
          workspace = lib.mkOption {
            type = lib.types.str;
            description = "Workspace selector, e.g. \"1\" or \"r[2-3]\"";
          };
          monitor = lib.mkOption { type = lib.types.nullOr lib.types.str; default = null; };
          default = lib.mkOption { type = lib.types.bool; default = false; };
        };
      };

      initial_layout = get_layout config.layouts.initial;
    in {
      options.layouts = lib.mkOption {
        type = lib.types.submodule {
          options = {
            layouts = lib.mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                options = {
                  monitors = lib.mkOption {
                    type = lib.types.listOf monitorType;
                    description = "Monitor settings";
                    default = [];
                  };
                  workspaces = lib.mkOption {
                    type = lib.types.listOf workspaceType;
                    description = "Workspace rules";
                    default = [];
                  };
                  command = lib.mkOption {
                    type = lib.types.str;
                    description = "Command to run when switching to layout";
                    default = "";
                  };
                  leave_command = lib.mkOption {
                    type = lib.types.str;
                    description = "Command to run when leaving the layout";
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

      config = {
        layouts =
          if config.host == "laptop" then
            let
              edp = { output = "eDP-1"; mode = "preferred"; position = "0x0"; };
            in {
              initial = "home";

              layouts = {
                none = {
                  monitors = [ edp ];
                  workspaces = [
                    { workspace = "1"; monitor = "eDP-1"; default = true; }
                    { workspace = "r[2-3]"; monitor = "eDP-1"; }
                  ];
                  command = "disable-other-monitors eDP-1";
                };

                extend = {
                  monitors = [
                    edp
                    { output = ""; }
                  ];
                  workspaces = [
                    { workspace = "1"; monitor = "eDP-1"; default = true; }
                  ];
                  command = "set-other-monitors-auto eDP-1";
                };

                home = {
                  monitors = [
                    edp
                    { output = "DP-5"; mode = "preferred"; position = "-1920x0"; }
                    { output = "DP-6"; mode = "preferred"; position = "-3840x0"; }
                    { output = "DP-7"; mode = "preferred"; position = "-1920x0"; }
                    { output = "DP-8"; mode = "preferred"; position = "-3840x0"; }
                  ];
                  workspaces = [
                    { workspace = "1"; monitor = "eDP-1"; default = true; }
                    { workspace = "r[2-3]"; monitor = "eDP-1"; }

                    { workspace = "4"; monitor = "DP-5"; default = true; }
                    { workspace = "r[5-6]"; monitor = "DP-5"; }
                    { workspace = "4"; monitor = "DP-7"; default = true; }
                    { workspace = "r[5-6]"; monitor = "DP-7"; }
                    { workspace = "7"; monitor = "DP-6"; default = true; }
                    { workspace = "r[8-9]"; monitor = "DP-6"; }
                    { workspace = "7"; monitor = "DP-8"; default = true; }
                    { workspace = "r[8-9]"; monitor = "DP-8"; }
                  ];
                };

                behns = {
                  monitors = [
                    edp
                    { output = "DP-3"; mode = "preferred"; position = "-2560x0"; scale = 1.5; }
                  ];
                  workspaces = [
                    { workspace = "1"; monitor = "eDP-1"; default = true; }
                  ];
                };

                mirror = {
                  monitors = [ edp ] ++ (builtins.map (i: {
                    output = "DP-${toString i}";
                    mirror = "eDP-1";
                  }) (lib.range 1 11));
                  leave_command = "disable-all-monitors";
                };

                present = {
                  command = "set-monitors-present eDP-1";
                  leave_command = "disable-all-monitors";
                };
              };
            }
          else {
            initial = "home";

            layouts.home = {
              monitors = [
                { output = "HDMI-A-1"; mode = "preferred"; position = "0x0"; }
                { output = "HDMI-A-2"; mode = "preferred"; position = "1920x0"; }
              ];
              workspaces = [
                { workspace = "1"; monitor = "HDMI-A-1"; default = true; }
                { workspace = "2"; monitor = "HDMI-A-1"; }
                { workspace = "3"; monitor = "HDMI-A-1"; }

                { workspace = "4"; monitor = "HDMI-A-2"; default = true; }
                { workspace = "5"; monitor = "HDMI-A-2"; }
                { workspace = "6"; monitor = "HDMI-A-2"; }
              ];
            };
          };

        #wayland.windowManager.hyprland.extraConfig = ''
        #  -- initial layout: ${config.layouts.initial}
        #  ${layout_lua config.layouts.initial}
        #'';

        home.packages = [
          current-layout
          set-layout
          set-monitors
          set-monitors-present
          disable-other-monitors
          set-other-monitors-auto
          disable-all-monitors
          guess-layout
        ];
      };
    };
}
