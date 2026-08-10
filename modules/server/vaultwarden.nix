{
  flake.modules.nixos.server = { config, pkgs, lib, ... }: let 
    default_borg_settings = import ./_borg_settings.nix { inherit config; };
    borg_settings = default_borg_settings // {
      group = "vaultwarden";
      paths = [ "/var/lib/vaultwarden" "/var/local/vaultwarden" ];
      exclude = [ "**/icon_cache/**" "**/tmp/**" ];
    };
  in {

    sops.secrets."vaultwarden/admin_token" = { owner = "vaultwarden"; };

    sops.secrets.vaultwarden_smtp_pw = { 
      owner = "vaultwarden"; 
      key = "mail/vaultwarden/pw";
    };

    sops.templates."vaultwarden.env" = {
      content = ''
      ADMIN_TOKEN='${config.sops.placeholder."vaultwarden/admin_token"}'
      SMTP_PASSWORD='${config.sops.placeholder.vaultwarden_smtp_pw}'
      '';
      owner = "vaultwarden";
    };

    sops.secrets.vaultwarden_mail_pw = { 
      owner = "maddy"; 
      key = "mail/vaultwarden/pw";
    };

    services.maddy = {
      ensureAccounts = [
        "vaultwarden@${config.services.maddy.primaryDomain}"
      ];
      ensureCredentials = {
        "vaultwarden@${config.services.maddy.primaryDomain}".passwordFile = config.sops.secrets.vaultwarden_mail_pw.path;
      };
    };

    services.vaultwarden = {
      enable = true;
      backupDir = "/var/local/vaultwarden/backup";
      environmentFile = config.sops.templates."vaultwarden.env".path;
      config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://vaultwarden.stroby.org";
        SIGNUPS_ALLOWED = true;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        # This example assumes a mailserver running on localhost,
        # thus without transport encryption.
        # If you use an external mail server, follow:
        #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        SMTP_HOST = "127.0.0.1";
        SMTP_PORT = 25;
        SMTP_SECURITY = "off";

        SMTP_USERNAME = "vaultwarden@stroby.org";

        SMTP_FROM = "vaultwarden@stroby.org";
        SMTP_FROM_NAME = "Vaultwarden server";
      };
    };

    # Fix permissons for borg
    systemd.services.vaultwarden.serviceConfig.StateDirectoryMode = lib.mkForce "0750";
    systemd.services.vaultwarden.serviceConfig.UMask = lib.mkForce "0027";
    systemd.tmpfiles.rules = [
      "d /var/local/vaultwarden/backup 0750 vaultwarden vaultwarden - -"
      "Z /var/local/vaultwarden/backup 0750 vaultwarden vaultwarden - -"
    ];

    web_services."vaultwarden" = {
      domains = "all";
      root = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
        extraConfig = ''
          client_max_body_size 50000M;
          proxy_read_timeout   600s;
          proxy_send_timeout   600s;
          send_timeout         600s;
        '';      
      };
    };

    services.borgbackup.jobs.fritz_behns_vaultwarden = borg_settings // {
      repo = "ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server/vaultwarden";
      startAt = "*-*-* 04:45";
    };

    services.borgbackup.jobs.proxy_vaultwarden = borg_settings // {
      repo = "ssh://root@138.199.203.38/backup/vaultwarden";
      startAt = "*-*-* 04:50";
    };
   
    systemd.services.borgbackup-job-fritz_behns_vaultwarden = {
      vpnConfinement = {
        enable = true;
        vpnNamespace = "fritz";
      };

      onFailure = [ "unit-status@%n.service" ];
      requires = [ "fritz_behns_vpn_check.service" ];
      after = [ "fritz_behns_vpn_check.service" ];
    };

    systemd.services.borgbackup-job-proxy_vaultwarden.onFailure = [ "unit-status@%n.service" ];
  };
}
