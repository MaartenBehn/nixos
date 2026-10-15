{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.extraConfig = #lua
      ''
      -- general
      hl.config({
        general = {
          border_size = 2,
          gaps_in = 3,
          gaps_out = 4,
          col = {
            active_border = { colors = { "rgb(98971A)", "rgb(CC241D)" }, angle = 45 },
            inactive_border = "0x00000000",
          },
        },
      })

      -- no gaps, borders or rounding when a workspace has only one window
      for _, selector in ipairs({ "w[t1]", "w[tg1]", "f[1]" }) do
        hl.workspace_rule({ workspace = selector, gaps_out = 0, gaps_in = 0 })
        hl.window_rule({
          match = { float = false, workspace = selector },
          border_size = 0,
          rounding = 0,
        })
      end

      -- decoration
      hl.config({
        decoration = {
          rounding = 0,
          -- active_opacity = 0.90,
          -- inactive_opacity = 0.90,
          -- fullscreen_opacity = 1.0,

          blur = {
            enabled = true,
            size = 3,
            passes = 2,
            brightness = 1,
            contrast = 1.4,
            ignore_opacity = true,
            noise = 0,
            new_optimizations = true,
            xray = true,
          },

          shadow = {
            enabled = true,
            offset = "0 2",
            range = 20,
            render_power = 3,
            color = "rgba(00000055)",
          },
        },
      })

      -- animations
      hl.config({ animations = { enabled = true } })

      hl.curve("fluent_decel", { type = "bezier", points = { { 0, 0.2 }, { 0.4, 1 } } })
      hl.curve("easeOutCirc", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } })
      hl.curve("easeOutCubic", { type = "bezier", points = { { 0.33, 1 }, { 0.68, 1 } } })
      hl.curve("fade_curve", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } })

      -- windows
      hl.animation({ leaf = "windowsIn", enabled = false, speed = 4, bezier = "easeOutCubic", style = "popin 20%" })
      hl.animation({ leaf = "windowsOut", enabled = false, speed = 4, bezier = "fluent_decel", style = "popin 80%" })
      hl.animation({ leaf = "windowsMove", enabled = true, speed = 2, bezier = "fluent_decel", style = "slide" })

      -- fade
      hl.animation({ leaf = "fadeIn", enabled = true, speed = 3, bezier = "fade_curve" })
      hl.animation({ leaf = "fadeOut", enabled = true, speed = 3, bezier = "fade_curve" })
      hl.animation({ leaf = "fadeSwitch", enabled = false, speed = 1, bezier = "easeOutCirc" })
      hl.animation({ leaf = "fadeShadow", enabled = true, speed = 10, bezier = "easeOutCirc" })
      hl.animation({ leaf = "fadeDim", enabled = true, speed = 4, bezier = "fluent_decel" })

      -- workspaces (styles: slide, slidevert, fade, slidefade, slidefadevert)
      hl.animation({ leaf = "workspaces", enabled = true, speed = 4, bezier = "easeOutCubic", style = "fade" })

      -- hl.animation({ leaf = "border", enabled = true, speed = 2.7, bezier = "easeOutCirc" })
      -- hl.animation({ leaf = "borderangle", enabled = true, speed = 30, bezier = "fluent_decel", style = "once" })
    '';
  };
}
