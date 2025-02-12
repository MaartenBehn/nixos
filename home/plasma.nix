{ pkgs, ... }:
{
  programs.plasma = {
    enable = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor.theme = "Bibata-Modern-Ice";
      iconTheme = "Papirus-Dark";
      wallpaper = "/home/stroby/nixos/wallpapers/life-is-strange.jpeg";
    };

    hotkeys.commands."trigger-alacritty" = {
      name = "Trigger Alacritty";
      key = "Meta+Space";
      command = "sh /home/stroby/nixos/trigger_alacritty.sh";
    };

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
    ];
  };
}
