{ domains, local_domain, config, ... }: {

  sops.secrets."vaultwarden/admin_token" = { owner = "vaultwarden"; };
  sops.secrets."mail/vaultwarden/pw" = { owner = "vaultwarden"; };

  sops.templates."vaultwarden.env" = {
    content = ''
      ADMIN_TOKEN='${config.sops.secrets."vaultwarden/admin_token"}'
      SMTP_PASSWORD='${config.sops.secrets."mail/vaultwarden/pw"}'
    '';
    owner = "vaultwarden";
  };

  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
    # be aware that this file must be created by hand (or via secrets management like sops)
    environmentFile = config.sops.templates."vaultwarden.env".path;
    config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://vaultwarden.stroby.ipv64.de";
        SIGNUPS_ALLOWED = false;

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        # This example assumes a mailserver running on localhost,
        # thus without transport encryption.
        # If you use an external mail server, follow:
        #   https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration
        SMTP_HOST = "127.0.0.1";
        SMTP_PORT = 25;
        SMTP_SSL = false;

        SMTP_USERNAME = "vaultwarden@stroby.ipv64.de";

        SMTP_FROM = "vaultwarden@stroby.ipv64.de";
        SMTP_FROM_NAME = "Vaultwarden server";
    };
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "vaultwarden.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
      };

      serverAliases = [
        "www.vaultwarden.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
