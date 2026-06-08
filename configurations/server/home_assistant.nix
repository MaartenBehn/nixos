{ pkgs, ... }: {
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

    # Store the seed file in /etc (read-only, managed by Nix)
  environment.etc."hass/known_devices_seed.yaml" = {
    text = ''
      ble_ecd5c07c38a6:
        name: Wallet
        mac: EC:D5:C0:7C:38:A6
        track: true
        icon: mdi:wallet

      ble_e089b7183343:
        name: Keys
        mac: E0:89:B7:18:33:43
        track: true
        icon: mdi:key
    '';
    user = "hass";
    group = "hass";
    mode = "0644";
  };

  # On every HA start, overwrite known_devices.yaml from the seed,
  # preserving any extra entries HA has added at runtime by merging them.
  systemd.services.home-assistant.serviceConfig.ExecStartPre =
    let
      mergeScript = pkgs.writeShellScript "seed-known-devices" ''
        SEED="/etc/hass/known_devices_seed.yaml"
        DEST="/var/lib/hass/known_devices.yaml"

        if [ ! -f "$DEST" ]; then
          # First boot — just copy the seed
          cp "$SEED" "$DEST"
          chown hass:hass "$DEST"
        else
          # Merge: seed entries overwrite existing, unknown runtime entries are kept
          ${pkgs.python3}/bin/python3 - <<'EOF'
import yaml, os

seed_path = "/etc/hass/known_devices_seed.yaml"
dest_path = "/var/lib/hass/known_devices.yaml"

with open(seed_path) as f:
    seed = yaml.safe_load(f) or {}

with open(dest_path) as f:
    existing = yaml.safe_load(f) or {}

# Runtime entries first, then seed overwrites tracked devices
merged = {**existing, **seed}

with open(dest_path, "w") as f:
    yaml.dump(merged, f, default_flow_style=False, allow_unicode=True)

os.chown(dest_path, 
  __import__("pwd").getpwnam("hass").pw_uid,
  __import__("grp").getgrnam("hass").gr_gid
)
EOF
        fi
      '';
    in
    "+${mergeScript}"; # '+' prefix runs with elevated privileges for chown  

  web_services."home" = {
    domains = "local";
    loc = {
      proxyPass = "http://127.0.0.1:8123/";
      proxyWebsockets = true;
    };
  };
}
