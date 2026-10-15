{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    home.packages = with pkgs; [ swayosd ];

    wayland.windowManager.hyprland.extraConfig = #lua
      ''
      -- swayosd: on-screen display for volume, brightness and lock keys
      hl.on("hyprland.start", function()
        hl.exec_cmd("swayosd-server")
      end)

      -- mute
      hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))

      -- brightness (also works on the lockscreen)
      hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise 5%+"), { locked = true })
      hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower 5%-"), { locked = true })
      hl.bind("SUPER + XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set 100%"), { locked = true })
      hl.bind("SUPER + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 0%"), { locked = true })

      -- volume (repeats when held, also works on the lockscreen)
      hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume +2 --max-volume=150"), { locked = true, repeating = true })
      hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume -2 --max-volume=150"), { locked = true, repeating = true })
      hl.bind("SUPER + F11", hl.dsp.exec_cmd("swayosd-client --output-volume +2 --max-volume=150"), { locked = true, repeating = true })
      hl.bind("SUPER + F12", hl.dsp.exec_cmd("swayosd-client --output-volume -2 --max-volume=150"), { locked = true, repeating = true })

      -- lock key indicators (fire on key release)
      hl.bind("CAPS + Caps_Lock", hl.dsp.exec_cmd("swayosd-client --caps-lock"), { release = true })
      hl.bind("Scroll_Lock", hl.dsp.exec_cmd("swayosd-client --scroll-lock"), { release = true })
      hl.bind("Num_Lock", hl.dsp.exec_cmd("swayosd-client --num-lock"), { release = true })
    '';

    xdg.configFile."swayosd/style.css".text = #css
      ''
      window {
          padding: 0px 10px;
          border-radius: 25px;
          border: 10px;
          background: alpha(#282828, 0.99);
      }

      #container {
          margin: 15px;
      }

      image, label {
          color: #FBF1C7;
      }

      progressbar:disabled,
      image:disabled {
          opacity: 0.95;
      }

      progressbar {
          min-height: 6px;
          border-radius: 999px;
          background: transparent;
          border: none;
      }
      trough {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: alpha(#DDDDDD, 0.2);
      }
      progress {
          min-height: inherit;
          border-radius: inherit;
          border: none;
          background: #FBF1C7;
      }
    '';
  };
}
