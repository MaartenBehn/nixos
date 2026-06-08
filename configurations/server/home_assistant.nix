{ pkgs, ... }:
let
  find_hub_scanner = pkgs.writeShellScriptBin "find_hub_scanner" ''
  #!/usr/bin/env bash
  set -euo pipefail

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
    response=$(${pkgs.curl}/bin/curl -sf -X POST \
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

    # Use -x (no -R) so output is spaced hex like "aa fe"
    timeout "''${SCAN_SECONDS}" \
      ${pkgs.bluez}/bin/hcidump -i hci0 -x 2>/dev/null \
    | ${pkgs.gawk}/bin/awk '
        /^>/ { if (buf) print buf; buf=$0; next }
        { buf = buf " " $0 }
        END { if (buf) print buf }
      ' > "$tmpfile" || true

    local total_lines found_feaa=0 found_fmdn=0
    total_lines=$(wc -l < "$tmpfile")
    log "Raw HCI events captured: $total_lines lines"

    log "--- Lines containing aa fe ---"
    ${pkgs.gnugrep}/bin/grep -i "aa fe" "$tmpfile" || log "(none found)"
    log "--- End aa fe lines ---"

    while IFS= read -r line; do
      if echo "$line" | ${pkgs.gnugrep}/bin/grep -qi "aa fe"; then
        (( found_feaa++ )) || true
        log "FEAA line: $line"

        if echo "$line" | ${pkgs.gnugrep}/bin/grep -qi "16 aa fe 40"; then
          (( found_fmdn++ )) || true
          log "FMDN match!"

          eid=$(echo "$line" \
            | ${pkgs.gnugrep}/bin/grep -oi "16 aa fe 40\( [0-9a-f][0-9a-f]\)\{1,20\}" \
            | ${pkgs.gnused}/bin/sed 's/16 aa fe 40//' \
            | tr -d ' \n' \
            | cut -c1-40)

          log "Extracted EID: '$eid'"

          if [[ -n "$eid" ]]; then
            seen["$eid"]=$(date +%s)
            log "Stored EID: $eid"
          else
            log "WARNING: EID extraction failed from line: $line"
          fi
        fi
      fi
    done < "$tmpfile"

    log "FEAA lines seen: $found_feaa, FMDN (0x40) matches: $found_fmdn"
    rm -f "$tmpfile"
  }

  report() {
    local now count=0
    now=$(date +%s)
    local -a expired=()

    log "Seen table has ''${#seen[@]} entries:"
    for eid in "''${!seen[@]}"; do
      local age=$(( now - ''${seen[$eid]} ))
      log "  EID $eid age=''${age}s window=''${SEEN_WINDOW}s"
      if (( age <= SEEN_WINDOW )); then
        (( count++ )) || true
      else
        expired+=("$eid")
        log "  -> expired"
      fi
    done

    for eid in "''${expired[@]:-}"; do
      unset "seen[$eid]"
    done

    log "Tags in range: $count"

    post_ha "sensor.findhub_tags_home" "$count" \
      '{"friendly_name":"Find Hub Tags Home","icon":"mdi:tag-multiple","unit_of_measurement":"tags"}'

    local presence="off"
    (( count > 0 )) && presence="on" || true
    post_ha "binary_sensor.tags_home" "$presence" \
      '{"friendly_name":"Any Tag Home","device_class":"presence"}'
  }

  log "Find Hub scanner starting..."
  log "HA_URL=''${HA_URL} SCAN_SECONDS=''${SCAN_SECONDS} SEEN_WINDOW=''${SEEN_WINDOW} LOOP_INTERVAL=''${LOOP_INTERVAL}"
  ${pkgs.bluez}/bin/hciconfig hci0 up || true

  while true; do
    scan_once
    report
    sleep "''${LOOP_INTERVAL}"
  done
'';in {
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
      SCAN_SECONDS  = "10";
      SEEN_WINDOW   = "60";
      LOOP_INTERVAL = "15";
    };

    serviceConfig = {
      ExecStart  = "${find_hub_scanner}/bin/find_hub_scanner";
      Restart    = "on-failure";
      RestartSec = "10s";
      User       = "root";
    };
  };
}
