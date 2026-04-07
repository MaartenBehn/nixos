{ pkgs, ... }:

let
  batteryListener = pkgs.writeShellScriptBin "battery-listener" ''
#!/bin/bash

# Get battery path
BAT_PATH=$(upower -e | grep BAT)

# Initialize last sent 10% step
LAST_SENT=-1

# Poll interval in seconds
INTERVAL=30

while true; do
    # Read battery percentage and state
    BAT_INFO=$(upower -i "$BAT_PATH")
    PERC=$(echo "$BAT_INFO" | awk '/percentage/ {gsub("%",""); print $2}')
    STATE=$(echo "$BAT_INFO" | awk '/state/ {print $2}')

    echo "$STATE $PERC%"

    if [ "$STATE" = "discharging" ]; then
        # Round down to nearest 10%
        CURRENT_STEP=$((PERC / 10 * 10))

        # Send update only if step changed
        if [ "$CURRENT_STEP" -ne "$LAST_SENT" ] && [ "$PERC" -le 98 ]; then
            curl -s http://localhost:8090/status -d "Server Power at $PERC%!"
            LAST_SENT=$CURRENT_STEP
        fi
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
}
