{ username, ... }: {
  services.borgbackup.jobs.notes = {
    paths = "/home/${username}/Notes";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/danbst/.ssh/id_ed25519";
    repo = "ssh://user@example.com:23/path/to/backups-dir/home-danbst";
    compression = "auto,zstd";
    startAt = "daily";
  };
}
