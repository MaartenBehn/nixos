{ ... }:
{
  services = {
    syncthing = {
      enable = true;
      user = "stroby";
      dataDir = "/home/stroby/";    # Default folder for new synced folders
      configDir = "/home/stroby/.config/syncthing";   # Folder for Syncthing's settings and keys
      guiAddress = "127.0.0.1:8384";
      settings.gui = {
        user = "stroby";
        password = "Syncthing+240803";
      };
    };
  };

   # Syncthing ports: 8384 for remote access to GUI
   # 22000 TCP and/or UDP for sync traffic
   # 21027/UDP for discovery
   # source: https://docs.syncthing.net/users/firewall.html
   networking.firewall.allowedTCPPorts = [ 22000 ];
   networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
