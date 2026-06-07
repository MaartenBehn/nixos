{
  /*
  flake.modules.nixos.hyprland = { pkgs, ... }: {
    boot = {
      plymouth = {
        enable = true;
        theme = "cuts";
        themePackages = with pkgs; [
          # By default we would install all themes
          (adi1090x-plymouth-themes.override {
            selected_themes = [ "cuts" ];
          })
        ];
      };

      # Intel igpu module 
      initrd.kernelModules = [ "i915" ];

      # Enable "Silent boot"
      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"           # tells Plymouth to stay in splash mode
        "udev.log_level=3"
        "systemd.show_status=auto"
        "rd.udev.log_level=3"  # quiet udev in initrd too
        "vt.global_cursor_default=0"  # hides the blinking cursor flash      
        "i915.fastboot=1"  # skips mode reset, eliminates the resolution flash entirely
      ];

      # Hide grub
      #loader.timeout = 0;
    };

    # Dont show tty console
    #console.enable = false;

    systemd.user.services.hyprland-plymouth-quit = {
      description = "Quit Plymouth after Hyprland starts";
      wantedBy = [ "hyprland-session.target" ];
      after = [ "hyprland-session.target" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.plymouth}/bin/plymouth quit --retain-splash";
      };
    };
  };
  */
}
