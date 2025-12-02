{ username, pkgs, ... }: 
let default_borg_settings = import ./borg_settings.nix;
in {
  # Notes Folders: 
  # /notes
  # 
  # Permissions: 2770 
  # 2 -> create all files with group of folder 
  # 770 -> only owner and group can acces it
  # set default facl for permissions
  #
  # sudo chgrp -R notes /notes
  # sudo chmod -R 2770 /notes
  # sudo setfacl -R -d -m g::rwx /notes
  # sudo setfacl -R -d -m o::--- /notes
  # 
  # show groups: getent group
  # show facl: getfacl 

  imports = [ 
    ./borg.nix 
  ];

  services.borgbackup.jobs.fritz_behns_notes = default_borg_settings // {
    group = "notes";
    paths = "/notes"; 
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/notes";
    startAt = "*-*-* 04:15";
  };

  services.borgbackup.jobs.proxy_notes = default_borg_settings // {
    group = "notes";
    paths = "/notes";
    repo = "ssh://root@138.199.203.38/backup/notes";
    startAt = "*-*-* 04:10";
  };
 
  systemd.services.borgbackup-job-fritz_behns_notes = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };

    onFailure = [ "unit-status@%n.service" ];
  };

  systemd.services.borgbackup-job-proxy_notes.onFailure = [ "unit-status@%n.service" ];
}
