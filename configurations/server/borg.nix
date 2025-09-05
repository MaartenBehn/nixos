{ pkgs, username, lib, config, ... }: {
  
  sops.secrets."wireguard/fritz_behns.conf" = { };

  vpnNamespaces.fritz = {
    enable = true;
    #wireguardConfigFile = config.sops.secrets."wireguard/fritz_behns.conf".path;
    wireguardConfigFile = "/home/stroby/.config/wireguard/fritz_behns.conf";
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

  systemd.services.borgbackup-job-notes = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };

    path = with pkgs; [
      curl
    ];
    postStart = lib.mkBefore ''
      curl ipinfo.io;
    '';
  };

  services.borgbackup.jobs.notes = {
    paths = "/home/${username}/Notes";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://Stroby@192.168.178.39/BackUp/asus_server/Notes";
    compression = "auto,zstd";
    startAt = "daily";
  };

}
