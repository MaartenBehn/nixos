{ inputs, ... }: {
  flake.modules.nixos.hyprland = { pkgs, ... }:{
    services.libinput.enable = true;
    services.xserver.xkb = {
      layout = "de";
      variant = "";
    }; 

    services.getty.autologinUser = "stroby";
    console.enable = true;

    # Disable wait for online befor login
    systemd.services."NetworkManager-wait-online".enable = false;

    programs.hyprland = {
      enable = true;

      package = inputs.hyprland.packages.${pkgs.system}.default;
      portalPackage =
        inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gtk" ];
        hyprland.default = [
          "gtk"
          "hyprland"
        ];
      };

      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };

    nix.settings = {
      substituters = ["https://hyprland.cachix.org"];
      trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    };

    security.pam.services.hyprlock = {
      allowNullPassword = false;
      startSession = false;
      text = ''
      auth    include login
      account include login
      '';
    };
  };

  flake.modules.homeManager.hyprland = {
    systemd.user.targets.hyprland-session.Unit.Wants = [
      "xdg-desktop-autostart.target"
    ];

    wayland.windowManager.hyprland = {
      enable = true;

      # set the Hyprland and XDPH packages to null to use the ones from the NixOS module
      package = null;
      portalPackage = null;

      xwayland = {
        enable = true;
        # hidpi = true;
      };
      # enableNvidiaPatches = false;
      systemd.enable = true;

      settings = {
        input = {
          kb_layout = "de";
          kb_options = "grp:alt_caps_toggle";
          numlock_by_default = true;
          repeat_delay = 300;
          follow_mouse = 0;
          float_switch_override_focus = 0;
          mouse_refocus = 0;
          sensitivity = 0;
          touchpad = {
            natural_scroll = true;
          };
        };

        general = {
          "$mainMod" = "SUPER";
        };

        misc = {
          disable_autoreload = true;
          disable_hyprland_logo = true;
          always_follow_on_dnd = true;
          layers_hog_keyboard_focus = true;
          animate_manual_resizes = false;
          enable_swallow = true;
          focus_on_activate = true;
          #new_window_takes_over_fullscreen = 2;
          middle_click_paste = false;
          enable_anr_dialog = false;
        };

        binds = {
          movefocus_cycles_fullscreen = true;
        };
      };
    };
  };
}
