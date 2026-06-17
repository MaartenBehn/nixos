{
  flake.modules.nixos.battery = { ... }: {
    services.upower = {
      enable = true;
    };
  };

  flake.modules.homeManager.battery-hyprland-notifications = { pkgs, config, ... }:
    let
      battery_monitor = pkgs.writeShellScriptBin "battery_monitor" ''
        BATTERY=$(upower -e | grep -i battery | head -1)
        NOTIFIED_15=false
        NOTIFIED_10=false
        NOTIFIED_5=false

        while true; do
          LEVEL=$(upower -i "$BATTERY" | grep percentage | grep -oP '\d+')
          STATE=$(upower -i "$BATTERY" | grep state | awk '{print $2}')

          if [ "$STATE" = "discharging" ]; then
            if [ "$LEVEL" -le 5 ] && [ "$NOTIFIED_5" = false ]; then
              notify-send \
              --urgency=critical \
              --app-name="Power Monitor" \
              "Battery Critical" \
              "Battery at $LEVEL%. Plug in now!"
              NOTIFIED_5=true
              NOTIFIED_10=true
              NOTIFIED_15=true

            elif [ "$LEVEL" -le 10 ] && [ "$NOTIFIED_10" = false ]; then
              notify-send \
              --urgency=normal \
              --app-name="Power Monitor" \
              "Battery Low" \
              "Battery at $LEVEL%."
              NOTIFIED_10=true
              NOTIFIED_15=true

            elif [ "$LEVEL" -le 15 ] && [ "$NOTIFIED_15" = false ]; then
              notify-send \
              --urgency=low \
              --app-name="Power Monitor" \
              "Battery Warning" \
              "Battery at $LEVEL%."
              NOTIFIED_15=true
            fi
          else
            # Reset all flags when charging or full
            NOTIFIED_15=false
            NOTIFIED_10=false
            NOTIFIED_5=false
          fi

          sleep 60
        done  
      '';
    in {

      wayland.windowManager.hyprland = {
        settings = {
          exec-once = [ 
            "sleep 0.6 && battery_monitor"
          ];
        };
      };

      home.packages = (with pkgs; [ 
        battery_monitor
      ]);
    };

    flake.modules.nixos.battery-server-notifications = { pkgs, ... }: let
      batteryListener = pkgs.writeShellScriptBin "battery-listener" ''
        #!/bin/bash

        # Get battery path
        BAT_PATH=$(upower -e | grep BAT)

        # Initialize last sent 10% step
        NEXT_SENT=100

        # Poll interval in seconds
        INTERVAL=30

        while true; do
          BAT_INFO=$(upower -i "$BAT_PATH")
          PERC=$(echo "$BAT_INFO" | awk '/percentage/ {gsub("%",""); print $2}')
          STATE=$(echo "$BAT_INFO" | awk '/state/ {print $2}')

          echo "$STATE $PERC%"

          if [ "$STATE" = "discharging" ]; then

            if [ "$PERC" -le "$NEXT_SENT" ] && [ "$PERC" -le 98 ]; then
              curl -s http://localhost:8090/status -d "Server Power at $PERC%"
              NEXT_SENT=$((PERC - 10))
            fi 
          else 
            NEXT_SENT=$((PERC - 10))
          fi

          # Wait before next check
          sleep $INTERVAL
        done  
        '';
    in {
      systemd.services.batteryListener = {
        description = "Battery D-Bus listener for low/critical alerts";
        after = [ "upower.service" ];
        wants = [ "upower.service" ];
        wantedBy = [ "network-online.target" ];

        path = with pkgs; [
          batteryListener
          upower
          dbus
          gawk
          curl
        ];
        script = "battery-listener";

        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = 10;
        };
      };
    };
}
