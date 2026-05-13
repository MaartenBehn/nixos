{ pkgs, ... }: {
  services.udev.packages = with pkgs; [ platformio-core.udev ];
 
  users.users."stroby" = {
    extraGroups = [ "dialout" ];
  };

}
