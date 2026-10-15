{
  flake.modules.homeManager.hyprland = {
    wayland.windowManager.hyprland.extraConfig = #lua
      ''
      -- System
      hl.window_rule({ match = { title = "^(rofi)$" }, pin = true })
      hl.window_rule({ match = { title = "^(waypaper)$" }, pin = true, float = true })

      -- Task bar programs
      hl.window_rule({
        match = { class = "^(nm-connection-editor)$" },
        float = true,
        move = { "monitor_w*0.4", "monitor_h*0.4" },
      })

      hl.window_rule({
        match = { title = "^(Mullvad VPN)$" },
        move = { "monitor_w-window_w-10", "monitor_h-window_h-40" },
      })

      hl.window_rule({
        match = { title = "^(Bluetooth)$" },
        float = true,
        move = { "monitor_w-window_w-10", "monitor_h-window_h-40" },
      })

      hl.window_rule({
        match = { class = "org.pulseaudio.pavucontrol" },
        float = true,
        size = { "monitor_w*0.4", "monitor_h*0.4" },
        move = { "monitor_w-monitor_w*0.4-10", "monitor_h-monitor_h*0.4-40" },
      })

      -- Overlays
      hl.window_rule({
        match = { title = "^(Picture-in-Picture)$" },
        float = true,
        pin = true,
        opacity = "1.0 override 1.0 override",
      })
      hl.window_rule({
        match = { title = "^(Firefox — Sharing Indicator)$" },
        float = true,
        move = { "0", "0" },
      })

      -- Sharing popup
      hl.window_rule({ match = { title = "^(Select what to share)$" }, float = true })
      hl.window_rule({
        match = { class = "^(xwaylandvideobridge)$" },
        opacity = "0.0 override",
        no_anim = true,
        no_initial_focus = true,
        max_size = { 1, 1 },
        no_blur = true,
      })

      -- File popups (by class)
      for _, class in ipairs({
        "file_progress", "confirm", "dialog", "download",
        "notification", "error", "confirmreset",
      }) do
        hl.window_rule({ match = { class = "^(" .. class .. ")$" }, float = true })
      end

      -- File popups (by title)
      for _, title in ipairs({
        "branchdialog", "Confirm to replace files",
        "File Operation Progress", "Save As",
      }) do
        hl.window_rule({ match = { title = "^(" .. title .. ")$" }, float = true })
      end

      for _, title in ipairs({ "Open File", "File Upload" }) do
        hl.window_rule({
          match = { title = "^(" .. title .. ")$" },
          float = true,
          size = { "<(monitor_w*0.9)", "<(monitor_h*0.9)" },
        })
      end

      -- Programs
      hl.window_rule({ match = { class = "^(firefox)$" }, idle_inhibit = "always" })

      hl.window_rule({ match = { title = "^(imv)$" }, float = true })
      hl.window_rule({ match = { title = "^(.*imv.*)$" }, opacity = "1.0 override 1.0 override" })

      hl.window_rule({ match = { title = "^(mpv)$" }, float = true, idle_inhibit = "always" })
      hl.window_rule({ match = { title = "^(.*mpv.*)$" }, opacity = "1.0 override 1.0 override" })

      hl.window_rule({
        match = { title = "^(Aseprite)$" },
        tile = true,
        opacity = "1.0 override 1.0 override",
      })

      hl.window_rule({
        match = { class = "^(Unity)$" },
        opacity = "1.0 override 1.0 override",
        idle_inhibit = "always",
      })

      hl.window_rule({ match = { class = "^(blender)$" }, float = false })

      -- Other
      hl.window_rule({ match = { title = "^(audacious)$" }, float = true })
      hl.window_rule({ match = { title = "^(Viewnior)$" }, float = true })
      hl.window_rule({ match = { title = "^(neovide)$" }, tile = true })
      hl.window_rule({ match = { title = "^(udiskie)$" }, float = true })

      -- xwayland
      hl.config({ xwayland = { force_zero_scaling = true } })
    '';
  };
}
