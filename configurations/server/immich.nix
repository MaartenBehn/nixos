{ domains, local_domain, config, ... }: 
let default_borg_settings = import ./borg_settings.nix;
in {
  imports = [ ./borg.nix ];

  services.immich = {
    enable = true;
    port = 2283;
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
    requires = [ "fritz_behns_vpn_check.service" ];
    after = [ "fritz_behns_vpn_check.service" ];
    onFailure = [ "unit-status@%n.service" ];
  };

  services.borgbackup.jobs.fritz_behns_immich = default_borg_settings // {
    user = "immich";
    group = "immich";
    paths = "/var/lib/immich";
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/immich";
    startAt = "Sat 04:00";
  };
}
