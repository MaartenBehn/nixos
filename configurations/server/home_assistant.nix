{ ... }: {
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
}
