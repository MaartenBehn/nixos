{ pkgs, username, lib, config, ... }: {
  
  sops.secrets."wireguard/fritz_behns_asus_borg.conf" = { 
    owner = "stroby";  
  };

  vpnNamespaces.fritz = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."wireguard/fritz_behns_asus_borg.conf".path;
    namespaceAddress = "192.168.16.1";
    bridgeAddress = "192.168.16.5";
 
    accessibleFrom = [
      "192.168.0.0/24"
    ];
    openVPNPorts = [{
      port = 22;
      protocol = "both";
    }];
  };

  
  systemd.services.borgbackup-job-fritz_behns_shibari_study = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };
  };

  services.borgbackup.jobs.fritz_behns_shibari_study = {
    paths = "/media/videos/ShibariStudy";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/study";
    compression = "auto,zstd";
    startAt = "month";
    user = "stroby";
  };
}
