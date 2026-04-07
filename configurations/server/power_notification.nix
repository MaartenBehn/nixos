{ pkgs, ... }:

let
  batteryListener = pkgs.writeShellScriptBin "battery-listener" ''

    BAT_PATH=$(upower -e | grep BAT)

    while read -r line; do
      PERC=$(upower -i $BAT_PATH | grep percentage | awk '{print $2}' | tr -d '%')
      STATE=$(upower -i $BAT_PATH | grep state | awk '{print $2}')

      if [ "$STATE" = "discharging" ]; then
        if [ "$PERC" -le 10 ]; then
          curl http://localhost:8090/status -d "Server Power at $PERC"
        fi
      fi
    done < <(dbus-monitor --system "type='signal',interface='org.freedesktop.UPower.Device'")
  '';
in
{
  systemd.services.batteryListener = {
    description = "Battery D-Bus listener for low/critical alerts";
    after = [ "upower.service" ];
    wants = [ "upower.service" ];

    path = [
      batteryListener
    ];
    script = "battery-listener";

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = 240;
    };
  };
}
