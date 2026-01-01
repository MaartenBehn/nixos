{ ... }: 
let default_borg_settings = import ./borg_settings.nix;
in {
  imports = [ 
    ./borg.nix 
  ];

  services.borgbackup.jobs.fritz_behns_music_ellie_minibot = default_borg_settings // {
    group = "media";
    paths = "/media/music/Ellie Minibot"; 
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/ellie_minibot_music";
    startAt = "month";
  };

  systemd.services.borgbackup-job-fritz_behns_music_ellie_minibot = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };

    onFailure = [ "unit-status@%n.service" ];
    requires = [ "fritz_behns_vpn_check.service" ];
    after = [ "fritz_behns_vpn_check.service" ];
  };

  systemd.services.borgbackup-job-proxy_notes.onFailure = [ "unit-status@%n.service" ];
}
