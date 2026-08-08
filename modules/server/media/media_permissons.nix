{
  flake.modules.nixos.server = { lib, ... }: {
    systemd.services = lib.genAttrs [
      "jellyfin"
      "lidarr"
      "radarr"
      "sonarr"
      "prowlarr"
      "whisparr"
      "qbittorrent"
      "slskd"
      "sabnzbd"
    ] (name: {
      serviceConfig.UMask = "0007";
    });

    systemd.tmpfiles.rules = [
      "Z /media 2770 stroby media - -"
      "d /media 2770 stroby media - -"
      "a+ /media - - - - default:group::rwx,default:group:media:rwx,default:mask::rwx,default:other::---"
    ];  
  };
}
