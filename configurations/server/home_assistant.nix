{ pkgs, ... }:
let
  find_hub_scanner = pkgs.writeShellScriptBin "find_hub_scanner" ''
  export PATH="${pkgs.bash}/bin:${pkgs.bluez}/bin:${pkgs.gawk}/bin:${pkgs.gnugrep}/bin:${pkgs.gnused}/bin:${pkgs.curl}/bin:$PATH"

  HA_URL="''${HA_URL:-http://localhost:8123}"
  HA_TOKEN="$(cat ''${HA_TOKEN_FILE:-/run/secrets/ha_token})"
  SCAN_SECONDS="''${SCAN_SECONDS:-10}"
  SEEN_WINDOW="''${SEEN_WINDOW:-60}"
  LOOP_INTERVAL="''${LOOP_INTERVAL:-15}"

  log() { echo "[$(date '+%H:%M:%S')] $*"; }

  log "Shell: $BASH_VERSION"
  log "Find Hub scanner starting..."

  tmpfile=$(mktemp)
  log "Scanning for ''${SCAN_SECONDS}s, dumping raw output..."

  timeout "''${SCAN_SECONDS}" \
    hcidump -i hci0 -x 2>/dev/null > "$tmpfile" || true

  log "Raw line count: $(wc -l < "$tmpfile")"
  log "--- First 20 raw lines ---"
  head -20 "$tmpfile"
  log "--- All lines with fe or aa ---"
  grep -i "fe\|aa" "$tmpfile" | head -20 || log "(none)"
  log "--- Done ---"

  rm -f "$tmpfile"
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
      SCAN_SECONDS  = "10";
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
