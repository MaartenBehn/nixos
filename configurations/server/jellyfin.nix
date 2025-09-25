{ domains, local_domain, ... }:
let default_borg_settings = import ./borg_settings.nix;
in {

  # Media Folders: 
  # /media
  # /mnt/Data/media
  # 
  # Permissions: 2770 
  # 2 -> create all files with group of folder 
  # 770 -> only owner and group can acces it
  # set default facl for permissions
  #
  # sudo chgrp -R media /media
  # sudo chgrp -R media /mnt/Data/media
  # sudo chmod -R 2770 /media
  # sudo chmod -R 2770 /mnt/Data/media
  # sudo setfacl -R -d -m g::rwx /media
  # sudo setfacl -R -d -m g::rwx /mnt/Data/media
  # sudo setfacl -R -d -m o::--- /media
  # sudo setfacl -R -d -m o::--- /mnt/Data/media
  # 
  # show groups: getent group
  # show facl: getfacl 

  imports = [ ./borg.nix ];
  
  users.groups.media.members = [ "jellyfin" "borg" ];
  
  services.jellyfin.enable = true;
  networking.firewall.allowedUDPPorts = [ 7359 8096 ];
  # Client Discovery (7359/UDP): Allows clients to discover Jellyfin on the local network. A broadcast message to this port will return detailed information about your server that includes name, ip-address and ID.
  
  networking.firewall.allowedTCPPorts = [ 8096 ];
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "media.${domain}"; 
    value = { 
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;
      };

      serverAliases = [
        "www.media.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));

  # Backups
  systemd.services.borgbackup-job-fritz_behns_shibari_study = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };
  };

  services.borgbackup.jobs.fritz_behns_shibari_study = default_borg_settings // {
    paths = "/media/videos_data/ShibariStudy";
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/study";
    startAt = "month";
  };
}
