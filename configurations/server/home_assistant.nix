{ pkgs, ... }:
let
  find_hub_scanner = pkgs.writeTextFile {
  name = "find_hub_scanner";
  executable = true;
  destination = "/bin/find_hub_scanner";
  text = ''
    #!${pkgs.python3}/bin/python3
    import asyncio
    import os
    import time
    import logging
    import requests
    from bleak import BleakScanner

    logging.basicConfig(
      level=logging.DEBUG,
      format="[%(asctime)s] %(levelname)s %(message)s",
      datefmt="%H:%M:%S"
    )
    log = logging.getLogger("findhub")

    HA_URL        = os.environ.get("HA_URL", "http://localhost:8123")
    HA_TOKEN_FILE = os.environ.get("HA_TOKEN_FILE", "/run/secrets/ha_token")
    SCAN_SECONDS  = int(os.environ.get("SCAN_SECONDS", "10"))
    SEEN_WINDOW   = int(os.environ.get("SEEN_WINDOW", "60"))
    LOOP_INTERVAL = int(os.environ.get("LOOP_INTERVAL", "15"))

    with open(HA_TOKEN_FILE) as f:
      HA_TOKEN = f.read().strip()

    # key -> last seen epoch
    seen: dict[str, float] = {}

    def post_ha(entity: str, state: str, attributes: dict):
      url = f"{HA_URL}/api/states/{entity}"
      headers = {
        "Authorization": f"Bearer {HA_TOKEN}",
        "Content-Type": "application/json",
      }
      payload = {"state": state, "attributes": attributes}
      log.info(f"POST {entity} = {state}")
      try:
        r = requests.post(url, headers=headers, json=payload, timeout=10)
        r.raise_for_status()
        log.info(f"POST ok ({r.status_code})")
      except Exception as e:
        log.error(f"POST failed: {e}")

    def detection_callback(device, advertisement_data):
      log.debug(
        f"Device: {device.address} "
        f"name={device.name!r} "
        f"rssi={advertisement_data.rssi} "
        f"service_uuids={advertisement_data.service_uuids} "
        f"service_data={advertisement_data.service_data!r} "
        f"manufacturer_data={advertisement_data.manufacturer_data!r}"
      )

      for uuid, data in advertisement_data.service_data.items():
        log.debug(f"  Service data UUID={uuid} data={data.hex()} len={len(data)}")
        if "feaa" in uuid.lower():
          log.info(f"  FEAA service found! first byte=0x{data[0]:02x}")
          if len(data) > 0 and data[0] == 0x40:
            eid = data[2:22].hex() if len(data) >= 22 else data.hex()
            log.info(f"  FMDN frame confirmed! EID={eid} addr={device.address}")
            seen[eid] = time.time()

    async def scan_cycle():
      log.info(f"Starting scan for {SCAN_SECONDS}s...")
      scanner = BleakScanner(detection_callback=detection_callback)
      await scanner.start()
      await asyncio.sleep(SCAN_SECONDS)
      await scanner.stop()
      log.info("Scan complete")

      now = time.time()
      expired = [k for k, t in seen.items() if now - t > SEEN_WINDOW]
      for k in expired:
        log.info(f"Expiring EID {k}")
        del seen[k]

      active = {k: v for k, v in seen.items() if now - v <= SEEN_WINDOW}
      count = len(active)
      log.info(f"Active tags: {count}")
      for eid, t in active.items():
        log.info(f"  EID={eid} age={now-t:.0f}s")

      post_ha("sensor.findhub_tags_home", str(count), {
        "friendly_name": "Find Hub Tags Home",
        "icon": "mdi:tag-multiple",
        "unit_of_measurement": "tags",
      })
      post_ha("binary_sensor.tags_home", "on" if count > 0 else "off", {
        "friendly_name": "Any Tag Home",
        "device_class": "presence",
      })

    async def main():
      log.info(f"Find Hub scanner starting")
      log.info(f"HA_URL={HA_URL} SCAN_SECONDS={SCAN_SECONDS} SEEN_WINDOW={SEEN_WINDOW} LOOP_INTERVAL={LOOP_INTERVAL}")
      while True:
        try:
          await scan_cycle()
        except Exception as e:
          log.error(f"Scan error: {e}", exc_info=True)
        log.info(f"Sleeping {LOOP_INTERVAL}s...")
        await asyncio.sleep(LOOP_INTERVAL)

    asyncio.run(main())
    '';
  };

  pythonEnv = pkgs.python3.withPackages (ps: with ps; [
    bleak
    requests
  ]);
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
      ExecStart  = "${pythonEnv}/bin/python3 ${find_hub_scanner}/bin/find_hub_scanner";
      Restart    = "on-failure";
      RestartSec = "10s";
      User       = "root";
    };  
  };
}
