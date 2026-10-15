{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
    wayland.windowManager.hyprland.extraConfig = #lua
      ''
      hl.config({
        general = { layout = "scrolling" },

        scrolling = {
          fullscreen_on_one_column = true,
          column_width = 1.0,
          explicit_column_widths = "0.25, 0.5, 1.0",
          focus_fit_method = 1,
          follow_focus = true,
        },
      })

      -- move focus
      hl.bind("SUPER + right", hl.dsp.layout("focus r"))
      hl.bind("SUPER + left", hl.dsp.layout("focus l"))
      hl.bind("SUPER + up", hl.dsp.layout("focus u"))
      hl.bind("SUPER + down", hl.dsp.layout("focus d"))

      -- window control
      hl.bind("SUPER + ALT + left", hl.dsp.layout("consume_or_expel prev"))
      hl.bind("SUPER + ALT + right", hl.dsp.layout("consume_or_expel next"))

      -- column width (cycles through explicit_column_widths)
      hl.bind("SUPER + CTRL + left", hl.dsp.layout("colresize -conf"))
      hl.bind("SUPER + CTRL + right", hl.dsp.layout("colresize +conf"))

      -- hl.bind("SUPER + ALT + up", hl.dsp.layout("swap up"))
      -- hl.bind("SUPER + ALT + down", hl.dsp.layout("swap down"))
      -- hl.bind("SUPER + CTRL + up", hl.dsp.window.resize({ x = 0, y = -80, relative = true }))
      -- hl.bind("SUPER + CTRL + down", hl.dsp.window.resize({ x = 0, y = 80, relative = true }))
    '';
  };
}
