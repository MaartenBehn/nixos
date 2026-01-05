{ domains, local_domain, config, pkgs, ... }: {

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

  environment.systemPackages = with pkgs; [ vaultwarden ];
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
    # be aware that this file must be created by hand (or via secrets management like sops)
    environmentFile = config.sops.templates."vaultwarden.env".path;
    config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://vaultwarden.stroby.ipv64.de";
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

        SMTP_USERNAME = "vaultwarden@stroby.ipv64.de";

        SMTP_FROM = "vaultwarden@stroby.ipv64.de";
        SMTP_FROM_NAME = "Vaultwarden server";
    };
  };

  web_services."vaultwarden" = {
    domains = "all";
    loc = {
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
}
