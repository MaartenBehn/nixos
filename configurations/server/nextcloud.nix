{ pkgs, config, ... }: 
let 
  cloud_domain = "cloud.stroby.ipv64.de";
  default_borg_settings = import ./borg_settings.nix;
in {
  imports = [ ./borg.nix ];

  sops.secrets."nextcloud/adminpass" = { 
    owner = "nextcloud";  
  };

  users.groups.notes.members = [ "nextcloud" "www-data" ];

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;

    database.createLocally = true;
    configureRedis = true;
    maxUploadSize = "16G";

    autoUpdateApps.enable = true;
    extraAppsEnable = true;

    settings = {
      overwriteprotocol = "https";
      default_phone_region = "DE";
    };

    config = {
      dbtype = "pgsql";
      adminuser = "admin";
      adminpassFile = config.sops.secrets."nextcloud/adminpass".path;
    };

    hostName = cloud_domain;
  };

  services.nginx.virtualHosts = {
    "${cloud_domain}" = {
      forceSSL = true;
      enableACME = true;
    };
  };

  systemd.services.borgbackup-job-fritz_behns_nextcloud = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "fritz";
    };
    onFailure = [ "unit-status@%n.service" ];
  };

  services.borgbackup.jobs.fritz_behns_nextcloud = default_borg_settings // {
    user = "nextcloud";
    paths = "/var/lib/nextcloud";
    repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/nextcloud";
    startAt = "Sat 04:15";
    exclude = [ "*/.rnd" ];
    prune.keep = {
      last = 6;
    };
  };
}
