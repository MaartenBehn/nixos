{ ... }:
{
  services = {
    syncthing = {
      enable = true;
      user = "stroby";
      dataDir = "/home/stroby/";    # Default folder for new synced folders
      configDir = "/home/stroby/.config/syncthing";   # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
    };
  };

  networking.firewall = {
    allowedTCPPorts = [ 8384 ];
    allowedUDPPorts = [ 8384 ];
  };

}
