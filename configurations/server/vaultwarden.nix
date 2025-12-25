{ domains, local_domain, config, ... }: {
  services.vaultwarden = {
    enable = true;
    backupDir = "/var/local/vaultwarden/backup";
    # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
    # be aware that this file must be created by hand (or via secrets management like sops)
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
    config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://bitwarden.example.com";
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

        SMTP_FROM = "admin@bitwarden.example.com";
        SMTP_FROM_NAME = "example.com Bitwarden server";
    };
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
}
