{ username, pkgs, ... }: 
let default_borg_settings = import ./borg_settings.nix;
in {
  imports = [ ./borg.nix ];

  # Backup
  systemd.services.borgbackup-job-fritz_behns_notes = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };

    #path = with pkgs; [
      #curl
      #];

    #preStart = ''
      #curl http://ipecho.net/plain; echo
      #cat ~/.ssh/id_ed25519.pub
      #ssh -o StrictHostKeychecking=no -i /home/borg/.ssh/id_ed25519 -v Stroby@192.168.178.39 "ls -la" 
    #''; 
  };
  users.groups.notes.members = [ "borg" ];



  services.borgbackup.jobs.fritz_behns_notes = default_borg_settings // {
    paths = "/notes"; 
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/notes";
    startAt = "*-*-* 04:15";
  };

  services.borgbackup.jobs.proxy_notes = default_borg_settings // {
    paths = "/notes";
    repo = "ssh://root@138.199.203.38/backup/notes";
    startAt = "*-*-* 04:10";
  };
}
