{
  flake.modules.nixos.hyprland = {
    programs.dconf.enable = true;
    services.getty.autologinUser = "stroby";
  };

  flake.modules.homeManager.hyprland = {
    systemd.user.targets.hyprland-session.Unit.Wants = [
      "xdg-desktop-autostart.target"
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      configType = "lua";

      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = null;
      portalPackage = null;

      xwayland.enable = true;
      systemd.enable = true;

      extraConfig = #lua
        '' 
        hl.monitor({ output = "", mode = "preffered", position = "auto", scale = 1 })

        hl.config({
          input = {
            kb_layout = "de",
            kb_options = "grp:alt_caps_toggle",
            numlock_by_default = true,
            repeat_delay = 300,
            follow_mouse = 0,
            float_switch_override_focus = 0,
            mouse_refocus = 0,
            sensitivity = 0,
            touchpad = {
              natural_scroll = true,
            },
          },

          misc = {
            disable_autoreload = true,
            disable_hyprland_logo = true,
            always_follow_on_dnd = true,
            layers_hog_keyboard_focus = true,
            animate_manual_resizes = false,
            enable_swallow = true,
            focus_on_activate = true,
            -- new_window_takes_over_fullscreen = 2,
            middle_click_paste = false,
            enable_anr_dialog = false,
          },

          binds = {
            movefocus_cycles_fullscreen = true,
          },
        })
      '';
    };
  };
}
