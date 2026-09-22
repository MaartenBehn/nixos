{
  flake.modules.nixos.solaar = { inputs, pkgs, ... }: {
    imports = [
      inputs.solaar.nixosModules.default
    ];

    hardware.logitech.wireless.enable = true;
    hardware.logitech.wireless.enableGraphical = true;

    services.solaar = {
      enable = true; # Enable the service
      package = pkgs.solaar; # The package to use
      window = "hide"; # Show the window on startup (show, *hide*, only [window only])
      batteryIcons = "regular"; # Which battery icons to use (*regular*, symbolic, solaar)
      extraArgs = ""; # Extra arguments to pass to solaar on startup
    };

    systemd.user.services.ydotoold = {
      description = "ydotool daemon";
      wantedBy = [ "graphical-session.target" ];
      serviceConfig = {
        ExecStart = "${pkgs.ydotool}/bin/ydotoold";
        Restart = "always";
      };
    };
  };


  flake.modules.homeManager.solaar = { lib, pkgs, config, ... }: 
    let 
      writableFile = path: text: (
        lib.hm.dag.entryAfter [ "linkGeneration" ] # bash
        ''
        rm -f "${path}"
        mkdir -p "$(dirname "${path}")"
        echo "${text}" > ${path}
      '');

      wallJumpScript = pkgs.writeShellScriptBin "rw-walljump" ''
        STATE_FILE="/tmp/rw_walljump.lock"

        if [ -f "$STATE_FILE" ]; then
          rm -f "$STATE_FILE"
          exit 0
        fi

        touch "$STATE_FILE"
        trap 'rm -f "$STATE_FILE"' EXIT

        # ydotool key codes: Space = 57, Left = 105, Right = 106
        KEY_SPACE="57"
        KEY_LEFT="30"
        KEY_RIGHT="32"

        while [ -f "$STATE_FILE" ]; do
          # Jump Left
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_SPACE}:1"
          sleep 0.01
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_LEFT}:1"
          sleep 0.01
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_SPACE}:0"
          
          [ ! -f "$STATE_FILE" ] && break
          sleep 0.3
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_LEFT}:0"
          
          [ ! -f "$STATE_FILE" ] && break

          # Jump Right
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_SPACE}:1"
          sleep 0.01
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_RIGHT}:1"
          sleep 0.01
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_SPACE}:0"
          
          [ ! -f "$STATE_FILE" ] && break
          sleep 0.3
          ${pkgs.ydotool}/bin/ydotool key "''${KEY_RIGHT}:0"
        done

        # Ensure all keys are released on toggle exit
        ${pkgs.ydotool}/bin/ydotool key "''${KEY_SPACE}:0" "''${KEY_LEFT}:0" "''${KEY_RIGHT}:0"
      '';

    in {
      home.packages = [
        pkgs.ydotool
        wallJumpScript
      ];

      home.activation = {
        write_solaar_config = (writableFile "/home/${config.username}/.config/solaar/config.yaml" ''
- 1.1.13
- _NAME: M720 Triathlon Multi-Device Mouse
  _absent: [hi-res-scroll, lowres-scroll-mode, scroll-ratchet, smart-shift, thumb-scroll-invert, thumb-scroll-mode, onboard_profiles, report_rate, report_rate_extended,
    dpi, dpi_extended, speed-change, backlight, backlight_level, backlight_duration_hands_out, backlight_duration_hands_in, backlight_duration_powered,
    backlight-timed, led_control, led_zone_, rgb_control, rgb_zone_, brightness_control, per-key-lighting, fn-swap, disable-keyboard-keys, crown-smooth,
    divert-crown, divert-gkeys, m-key-leds, mr-key-led, multiplatform, gesture2-gestures, gesture2-divert, gesture2-params, sidetone, equalizer, adc_power_management]
  _battery: 4096
  _modelId: B015405E0000
  _sensitive: {change-host: false, divert-keys: true, hires-smooth-invert: false, persistent-remappable-keys: false, reprogrammable-keys: false}
  _serial: AADD5386
  _unitId: DC3EEBF2
  _wpid: 405E
  change-host: null
  divert-keys: {82: 0, 83: 1, 86: 1, 91: 1, 93: 1, 208: 1}
  hires-scroll-mode: false
  hires-smooth-invert: false
  hires-smooth-resolution: true
  persistent-remappable-keys: null
  pointer_speed: 256
  reprogrammable-keys: {80: 80, 81: 81, 82: 82, 83: 83, 86: 86, 91: 91, 93: 93, 208: 208}
        '');

        write_solaar_rules = (writableFile "/home/${config.home.username}/.config/solaar/rules.yaml" ''
%YAML 1.3
---
- Key: [MultiPlatform Gesture Button, pressed]
- KeyPress:
  - z
  - click
...
---
- Key: [Forward Button, pressed]
- KeyPress:
  - u
  - click
...
---
- Key: [Back Button, pressed]
- KeyPress:
  - i
  - click
...
---
- Key: [Left Tilt, pressed]
- Execute: ${wallJumpScript}/bin/rw-walljump
...
---
- Key: [Right Tilt, pressed]
- KeyPress:
  - p
  - click
...      
        '');

      };
    };
}
