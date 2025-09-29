{ username, lib, inputs, ... }: 

let 
  writableFile = path: text: (
    lib.hm.dag.entryAfter [ "linkGeneration" ] # bash
    ''
      rm -f "${path}"
      mkdir -p "$(dirname "${path}")"
      echo "${text}" > ${path}
    '');
in {

  imports = [
    inputs.solaar.nixosModules.default
  ];

  home.activation = {
    write_solaar_config = (writableFile "/home/${username}/.config/solaar/config.yaml" ''
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
  
  write_solaar_rules = (writableFile "/home/${username}/.config/solaar/rules.yaml" ''
%YAML 1.3
---
- Key: [MultiPlatform Gesture Button, pressed]
- KeyPress:
  - [Super_L, d]
  - click
...
---
- Key: [Forward Button, pressed]
- KeyPress:
  - K
  - click
...
---
- Key: [Back Button, pressed]
- KeyPress:
  - L
  - click
...
---
- Key: [Left Tilt, pressed]
- KeyPress:
  - O
  - click
...
---
- Key: [Right Tilt, pressed]
- KeyPress:
  - P
  - click
...      
    '');

  };
}
