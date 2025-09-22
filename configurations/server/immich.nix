{ domains, local_domain, config, pkgs-unstable, username, ... }: {
  imports = [ ./borg.nix ];

  services.immich = {
    enable = true;
    port = 2283;
    package = pkgs-unstable.immich; 
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "immich.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://[::1]:${toString config.services.immich.port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';      
      };

      serverAliases = [
        "www.immich.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));

  systemd.services.borgbackup-job-fritz_behns_immich = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };
  };

  services.borgbackup.jobs.fritz_behns_immich = {
    paths = "/var/lib/immich";
    encryption.mode = "none";
    environment.BORG_RSH = "ssh -i /home/${username}/.ssh/id_ed25519";
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/immich";
    compression = "auto,zstd";
    startAt = "Sat 04:00";
    user = "immich";
    prune.keep = {
      last = 2;
    };
  };
}
