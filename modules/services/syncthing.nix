{
  flake.modules.nixos.syncthing = { config, ... }: {
    services = {
      syncthing = {
        enable = true;
        user = "${config.username}";
        dataDir = "/home/${config.username}/";                      # Default folder for new synced folders
        configDir = "/home/${config.username}/.config/syncthing";   # Folder for Syncthing's settings and keys
        overrideDevices = false;
        overrideFolders = false;
      };
    };
  };
}
