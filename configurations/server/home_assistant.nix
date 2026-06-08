{ pkgs, ... }:
let
  find_hub_scanner = pkgs.writeShellScriptBin "find_hub_scanner" ''
  export PATH="${pkgs.bash}/bin:${pkgs.bluez}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.curl}/bin:$PATH"

  HA_URL="''${HA_URL:-http://localhost:8123}"
  HA_TOKEN="$(cat ''${HA_TOKEN_FILE:-/run/secrets/ha_token})"
  SCAN_SECONDS="''${SCAN_SECONDS:-10}"
  SEEN_WINDOW="''${SEEN_WINDOW:-60}"
  LOOP_INTERVAL="''${LOOP_INTERVAL:-15}"

  declare -A seen

  log() { echo "[$(date '+%H:%M:%S')] $*"; }

  post_ha() {
    local entity="$1" state="$2" attrs="$3"
    log "POST $entity = $state"
    local response
    response=$(curl -sf -X POST \
      -H "Authorization: Bearer $HA_TOKEN" \
      -H "Content-Type: application/json" \
      -d "{\"state\":\"$state\",\"attributes\":$attrs}" \
      "$HA_URL/api/states/$entity" 2>&1) \
      && log "POST ok" \
      || log "POST failed: $response"
  }

  scan_once() {
    local tmpfile
    tmpfile=$(mktemp)
    log "Scanning for ''${SCAN_SECONDS}s..."

    # Use decoded text output (no flags) and track bdaddr + service data type
    timeout "''${SCAN_SECONDS}" \
      hcidump -i hci0 2>/dev/null \
    | awk '
        /^>/ {
          if (buf) print buf
          buf = $0
          next
        }
        { buf = buf "\n" $0 }
        END { if (buf) print buf }
      ' > "$tmpfile" || true

    local total_events found=0
    total_events=$(grep -c "^>" "$tmpfile" || true)
    log "HCI events captured: $total_events"

    # Each record is a full multi-line event joined by \n
    # Find events that contain BOTH a bdaddr AND "Unknown type 0x16 with 24 bytes"
    # (the FMDN frame is always 24 bytes via service data type 0x16)
    while IFS= read -r record; do
      if echo "$record" | grep -q "Unknown type 0x16 with 24 bytes"; then
        # Extract the bdaddr as a stable-enough identifier within scan window
        bdaddr=$(echo "$record" | grep -o "bdaddr [0-9A-F:]*" | head -1 | awk '{print $2}')
        if [[ -n "$bdaddr" ]]; then
          (( found++ )) || true
          log "Find Hub tag detected at bdaddr: $bdaddr"
          seen["$bdaddr"]=$(date +%s)
        fi
      fi
    done < <(awk 'BEGIN{RS="^>"} NR>1 {print}' "$tmpfile")

    log "Find Hub tags detected this scan: $found"
    rm -f "$tmpfile"
  }

  report() {
    local now count=0
    now=$(date +%s)
    local -a expired=()

    log "Seen table has ''${#seen[@]} entries:"
    for key in "''${!seen[@]}"; do
      local age=$(( now - ''${seen[$key]} ))
      log "  $key age=''${age}s"
      if (( age <= SEEN_WINDOW )); then
        (( count++ )) || true
      else
        expired+=("$key")
        log "  -> expired"
      fi
    done

    for key in "''${expired[@]:-}"; do
      unset "seen[$key]"
    done

    log "Tags in range: $count"

    post_ha "sensor.findhub_tags_home" "$count" \
      '{"friendly_name":"Find Hub Tags Home","icon":"mdi:tag-multiple","unit_of_measurement":"tags"}'

    local presence="off"
    (( count > 0 )) && presence="on" || true
    post_ha "binary_sensor.tags_home" "$presence" \
      '{"friendly_name":"Any Tag Home","device_class":"presence"}'
  }

  log "Shell: $BASH_VERSION"
  log "Find Hub scanner starting..."
  hciconfig hci0 up || true

  while true; do
    scan_once
    report
    sleep "''${LOOP_INTERVAL}"
  done
'';

in {
  imports = [
    ./mosquitto.nix
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Use dbus-broker (required by HA's bluetooth integration)
  services.dbus.implementation = "broker";

  
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "google_translate"
      "tasmota"

      "bluetooth"
      "bluetooth_le_tracker"
      "bluetooth_adapters"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};

      http = {
        # For extra security set this to only accept connections on localhost if NGINX is on the same machine
        # Uncommenting this will mean that you can only reach Home Assistant using the proxy, not directly via IP from other clients.
        server_host = "127.0.0.1";
        use_x_forwarded_for = true;
        # You must set the trusted proxy IP address so that Home Assistant will properly accept connections
        # Set this to your NGINX machine IP, or localhost if hosted on the same machine.
        trusted_proxies = "127.0.0.1";
      };

      # Enable the bluetooth integration
      bluetooth = {};

      # BLE device tracker
      device_tracker = [
        {
          platform = "bluetooth_le_tracker";
          interval_seconds = 12;
          consider_home = 180;  # seconds before marking "away"
          track_new_devices = true;
        }
      ];

      # Optional: enable the default logger to see BLE discovery
      logger.default = "info";
    };
  };
 
  web_services."home" = {
    domains = "local";
    loc = {
      proxyPass = "http://127.0.0.1:8123/";
      proxyWebsockets = true;
    };
  };

  sops.secrets."home_assistant/token" = { owner = "root"; };

  systemd.services.findhub-scanner = {
    description = "Find Hub BLE presence scanner";
    after    = [ "bluetooth.target" "home-assistant.service" "sops-nix.service" ];
    wants    = [ "bluetooth.target" ];
    wantedBy = [ "multi-user.target" ];

    environment = {
      HA_URL        = "http://localhost:8123";
      HA_TOKEN_FILE = "/run/secrets/home_assistant/token";
      SCAN_SECONDS  = "120";
      SEEN_WINDOW   = "60";
      LOOP_INTERVAL = "15";
    };

    serviceConfig = {
      ExecStart  = "${pkgs.bash}/bin/bash ${find_hub_scanner}/bin/find_hub_scanner";
      Restart    = "on-failure";
      RestartSec = "10s";
      User       = "root";
    };  
  };
}
