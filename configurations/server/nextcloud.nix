{ pkgs, config, ... }: 
let 
  cloud_domain = "cloud.stroby.ipv64.de";
  onlyoffice_domain = "office.stroby.ipv64.de";
in {
  sops.secrets."nextcloud/adminpass" = { 
    owner = "nextcloud";  
  };

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud30;

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

  services.onlyoffice = {
    enable = true;
    hostname = onlyoffice_domain;
  };

  services.nginx.virtualHosts = {
    "${cloud_domain}" = {
      forceSSL = true;
      enableACME = true;
    };

    "${onlyoffice_domain}" = {
      forceSSL = true;
      enableACME = true;
    };
  };
}
