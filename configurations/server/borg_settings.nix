{
  encryption.mode = "none";
  environment.BORG_RSH = "ssh -i /home/borg/.ssh/id_ed25519 -o StrictHostKeychecking=no";
  environment.BORG_RELOCATED_REPO_ACCESS_IS_OK = "yes";
  environment.BORG_UNKNOWN_UNENCRYPTED_REPO_ACCESS_IS_OK = "yes";
  user = "borg";
  compression = "auto,zstd";
  startAt = "*-*-* 03:00";
}
