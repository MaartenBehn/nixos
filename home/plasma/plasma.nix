{ terminal, inputs, ... }:
{
  imports = [
    inputs.plasma-manager.homeManagerModules.plasma-manager
  ];

  programs.plasma = {
    enable = true;

    # Spectacle
    shortcuts = {
      "org.kde.spectacle.desktop"."ActiveWindowScreenShot" = [ ];
      "org.kde.spectacle.desktop"."CurrentMonitorScreenShot" = [ ];
      "org.kde.spectacle.desktop"."FullScreenScreenShot" = [ ];
      "org.kde.spectacle.desktop"."OpenWithoutScreenshot" = [ ];
      "org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Print";
      "org.kde.spectacle.desktop"."WindowUnderCursorScreenShot" = [];
      "org.kde.spectacle.desktop"."_launch" = [];
    };
    configFile = {
      "spectaclerc"."General"."clipboardGroup" = "PostScreenshotCopyImage";
    };

    kscreenlocker = {
      autoLock = false;
    };
    session.general.askForConfirmationOnLogout = false;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "Bibata-Modern-Ice";
      iconTheme = "Papirus-Dark";
      wallpaper = "/home/stroby/nixos/wallpapers/life-is-strange.jpeg";
    };
 
    hotkeys.commands."trigger-terminal" = {
      name = "Trigger Terminal";
      key = "Meta+Space";
      command = (if terminal == "kitty" then "trigger_kitty_kde" else "trigger_alacritty_kde");
    };
    
    window-rules = [
      {
        description = "Alacritty Fullscreen";
        match = {
          window-class = {
            value = "alacritty";
            type = "substring";
          };
          window-types = [ "normal" ];
        };
        apply = {
          fullscreen = {
            value = true;
            apply = "force";
          };
        };
      }
      {
        description = "Kitty Fullscreen";
        match = {
          window-class = {
            value = "kitty";
            type = "substring";
          };
          window-types = [ "normal" ];
        };
        apply = {
          fullscreen = {
            value = true;
            apply = "force";
          };
        };
      }

    ];

    # cat /proc/bus/input/devices 
    input.touchpads = [
/*
I: Bus=0018 Vendor=04f3 Product=310d Version=0100
N: Name="ASUE1407:00 04F3:310D Keyboard"
P: Phys=i2c-ASUE1407:00
S: Sysfs=/devices/platform/AMDI0010:01/i2c-0/i2c-ASUE1407:00/0018:04F3:310D.0001/input/input11
U: Uniq=
H: Handlers=sysrq kbd leds event6
B: PROP=0
B: EV=120013
B: KEY=1000000000007 ff800000000007ff febeffdfffefffff fffffffffffffffe
B: MSC=10
B: LED=1
*/
      { 
        disableWhileTyping = true;
        enable = true;
        leftHanded = true;
        name = "ASUE1407:00 04F3:310D Keyboard";
        naturalScroll = true;
        pointerSpeed = 0;
        productId = "310d";
        tapToClick = true;
        vendorId = "04f3";       
      }
    ];

    # find /nix -name plasmoids
    # ls /nix/store/zk0050nbaf8cmr33n80i64lv6i6dprq7-plasma-workspace-6.2.1.1/share/plasma/plasmoids

    panels = [
      {
        location = "bottom";
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          #{
          #  name = "org.kde.plasma.kickoff";
          #  config = {
          #    General = {
          #      icon = "nix-snowflake-white";
          #      alphaSort = true;
          #    };
          #  };
          #}
          # Or you can configure the widgets by adding the widget-specific options for it.
          # See modules/widgets for supported widgets and options for these widgets.
          # For example:
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "nix-snowflake-white";
            };
          }
          # Adding configuration to the widgets can also for example be used to
          # pin apps to the task-manager, which this example illustrates by
          # pinning dolphin and konsole to the task-manager by default with widget-specific options.
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:firefox.desktop"
                "applications:obsidian.desktop"
              ];
            };
          }

          {
            name = "org.kde.plasma.systemmonitor.cpu";
          }
          {
            name = "org.kde.plasma.systemmonitor.memory";
          }
          {
            name = "org.kde.plasma.systemmonitor.net";
          }

          # Or you can do it manually, for example:
          #{
          #  name = "org.kde.plasma.icontasks";
          #  config = {
          #    General = {
          #      launchers = [
          #        "applications:org.kde.dolphin.desktop"
          #        "applications:org.kde.konsole.desktop"
          #      ];
          #    };
          #  };
          #}
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.marginsseparator"
          # If you need configuration for your widget, instead of specifying the
          # the keys and values directly using the config attribute as shown
          # above, plasma-manager also provides some higher-level interfaces for
          # configuring the widgets. See modules/widgets for supported widgets
          # and options for these widgets. The widgets below shows two examples
          # of usage, one where we add a digital clock, setting 12h time and
          # first day of the week to Sunday and another adding a systray with
          # some modifications in which entries to show.
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              time.format = "24h";
            };
          }
          {
            systemTray.items = {
              # We explicitly show bluetooth and battery
              shown = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
              ];
              # And explicitly hide networkmanagement and volume
              hidden = [

              ];
            };
          }
        ];
        #hiding = "autohide";
      }
    ];
  };
}
