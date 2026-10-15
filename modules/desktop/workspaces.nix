{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.extraConfig = #lua
      ''
      -- workspaces 1-10 (key 0 is workspace 10)
      for i = 1, 10 do
        local key = i % 10

        -- switch to workspace
        hl.bind("SUPER + " .. key, hl.dsp.focus({ workspace = i }))

        -- move window to workspace, without following it
        hl.bind("SUPER + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
      end
    '';
  };
}
