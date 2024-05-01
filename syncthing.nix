
{ pkgs, ... }:

{
  services = {
    syncthing = {
        enable = true;
        user = "stroby";
        dataDir = "/home/stroby/";    # Default folder for new synced folders
        configDir = "/home/stroby/.config/syncthing";   # Folder for Syncthing's settings and keys
    };
  };
}
