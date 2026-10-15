{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland.extraConfig = #lua
    ''
      local mainMod = "SUPER"

      local function exec(cmd)
        return hl.dsp.exec_cmd(cmd)
      end

      -- show keybinds list
      hl.bind(mainMod .. " + F1", exec("show-keybinds"))

      -- keybindings
      hl.bind(mainMod .. " + Q", hl.dsp.window.close())
      hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
      hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
      hl.bind(mainMod .. " + T", exec("toggle_oppacity"))

      -- System shortcuts
      hl.bind(mainMod .. " + Escape", exec("hyprlock"))
      hl.bind(mainMod .. " + SHIFT + Escape", exec("power-menu"))
      hl.bind(mainMod .. " + D", exec("rofi -show drun || pkill rofi"))
      hl.bind(mainMod .. " + SHIFT + B", exec("toggle_waybar"))
      hl.bind(mainMod .. " + W", exec("wallpaper-picker"))
      hl.bind(mainMod .. " + N", exec("swaync-client -t -sw"))

      -- Program shortcuts
      hl.bind(mainMod .. " + Space", exec("kitty -d $(hyprcwd)"))
      hl.bind(mainMod .. " + B", exec("firefox"))
      hl.bind(mainMod .. " + O", exec("obsidian"))
      hl.bind(mainMod .. " + SHIFT + E", exec("kitty -d $(hyprcwd) -e yazi"))
      hl.bind(mainMod .. " + E", exec("nemo"))
      hl.bind(mainMod .. " + M", exec("thunderbird"))
      hl.bind(mainMod .. " + SHIFT + V", exec("open_vim_cheat_sheet"))

      -- Other shortcuts
      hl.bind(mainMod .. " + C", exec("hyprpicker -a"))
      hl.bind(mainMod .. " + Z", exec("woomer-current"))

      -- screenshot
      hl.bind("Print", exec("screenshot --copy"))
      hl.bind(mainMod .. " + Print", exec("screenshot --md-copy"))

      -- media controls
      -- hl.bind("XF86AudioMute", exec("pamixer -t"))
      hl.bind("XF86AudioPlay", exec("playerctl play-pause"))
      hl.bind("XF86AudioNext", exec("playerctl next"))
      hl.bind("XF86AudioPrev", exec("playerctl previous"))
      hl.bind("XF86AudioStop", exec("playerctl stop"))

      -- workspace scrolling
      hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
      hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))

      -- clipboard manager
      hl.bind(
        mainMod .. " + V",
        exec("cliphist list | rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' | cliphist decode | wl-copy")
      )

      -- locked binds (previously commented out)
      -- hl.bind("XF86MonBrightnessUp", exec("brightnessctl set 5%+"), { locked = true })
      -- hl.bind("XF86MonBrightnessDown", exec("brightnessctl set 5%-"), { locked = true })
      -- hl.bind(mainMod .. " + XF86MonBrightnessUp", exec("brightnessctl set 100%+"), { locked = true })
      -- hl.bind(mainMod .. " + XF86MonBrightnessDown", exec("brightnessctl set 100%-"), { locked = true })

      -- repeating binds (previously commented out)
      -- hl.bind("XF86AudioRaiseVolume", exec("pamixer -i 2"), { repeating = true })
      -- hl.bind("XF86AudioLowerVolume", exec("pamixer -d 2"), { repeating = true })

      -- mouse bindings
      hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
      hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
    '';
  };
}
