{ domains, local_domain, ... }:
{
  services = {
    syncthing = {
      enable = true;
      user = "syncthing";
      dataDir = "/var/lib/syncthing/default";      # Default folder for new synced folders
      configDir = "/var/lib/syncthing/config";  # Folder for Syncthing's settings and keys
      guiAddress = "0.0.0.0:8384";
      settings.gui = {
        user = "stroby";
        password = "Syncthing+240803";
      };
      overrideDevices = false;
      overrideFolders = false;
    };
  };

   # Syncthing ports: 8384 for remote access to GUI
   # 22000 TCP and/or UDP for sync traffic
   # 21027/UDP for discovery
   # source: https://docs.syncthing.net/users/firewall.html
   networking.firewall.allowedTCPPorts = [ 22000 ];
   networking.firewall.allowedUDPPorts = [ 22000 21027 ];

  users.groups.notes.members = [ "syncthing" ];
 
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "syncthing.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8384/"; 
      };

      serverAliases = [
        "www.syncthing.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
