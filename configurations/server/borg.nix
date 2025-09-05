{ username, config, ... }: {
  
  sops.secrets."wireguard/fritz_behns.conf" = { };

  vpnNamespaces.fritz = {
    enable = true;
    wireguardConfigFile = config.sops.secrets."wireguard/fritz_behns.conf".path;
    
    accessibleFrom = [
      "192.168.0.0/24"
    ];
    openVPNPorts = [{
      port = 22;
      protocol = "both";
    }];
  };

  systemd.services.borgbackup.vpnConfinement = {
    enable = true;
    vpnNamespace = "fritz";
  };

  services.borgbackup.jobs.notes = {
    paths = "/home/${username}/Notes";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://behnserver/BackUp/asus_server/Notes";
    compression = "auto,zstd";
    startAt = "daily";
  };

}
