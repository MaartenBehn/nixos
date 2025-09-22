{ username, pkgs, ... }: {
  imports = [ ./borg.nix ];

  # Backup
  systemd.services.borgbackup-job-fritz_behns_notes = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };
  };

  services.borgbackup.jobs.fritz_behns_notes = {
    paths = "/home/${username}/Notes";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/notes";
    compression = "auto,zstd";
    startAt = "*-*-* 04:15";
    user = "stroby";
  };

  services.borgbackup.jobs.proxy_notes = {
    paths = "/home/${username}/Notes";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://root@138.199.203.38/backup/notes";
    compression = "auto,zstd";
    startAt = "*-*-* 04:10";
    user = "stroby";
  };
}
