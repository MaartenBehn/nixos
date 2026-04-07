{ pkgs, ... }:

let
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
}
