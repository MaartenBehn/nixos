{
  my.secrets.server."mail_admin_password" = { 
    bitwarden = { name = "Mail Admin"; field = "password"; };
    owner = "maddy"; 
  };

  my.secrets.server."maddy_brevo_smtp_password" = {
    bitwarden = { name = "Brevo"; field = "maddy_key"; };
    owner = "maddy";
  };

  flake.modules.nixos.server = { config, options, pkgs, ... }: 
    let 
      main_domain = "mail.${config.domains.public}";
    in {

      users.users.maddy.extraGroups = [ "acme" ];

      services.maddy = {
        enable = true;
        openFirewall = true;
        primaryDomain = main_domain;
        ensureAccounts = [
          "admin@${main_domain}"
        ];
        ensureCredentials = {
          "admin@${main_domain}".passwordFile = config.my.secrets."mail_admin_password".path;
        };

        tls = {
          loader = "file";
          certificates = [{
            keyPath = "/var/lib/acme/${config.domains.public}/key.pem";
            certPath = "/var/lib/acme/${config.domains.public}/fullchain.pem";
          }];
        };

        # Enable TLS listeners. Configuring this via the module is not yet
        # implemented, see https://github.com/NixOS/nixpkgs/pull/153372
        config = builtins.replaceStrings [
          "imap tcp://0.0.0.0:143"
          "submission tcp://0.0.0.0:587"
          ''
            target.remote outbound_delivery {
              limits {
                destination rate 20 1s
                destination concurrency 10
              }
              mx_auth {
                dane
                mtasts {
                  cache fs
                  fs_dir mtasts_cache/
                }
                local_policy {
                    min_tls_level encrypted
                    min_mx_level none
                }
              }
            }
          ''
        ] [
            "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
            "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
            ''
              target.smtp outbound_delivery {
                targets tcp://smtp-relay.brevo.com:587
                starttls yes
                auth plain "ae8fbc001@smtp-brevo.com" "{env:MADDY_BREVO_SMTP_PASSWORD}"
              }
            ''
          ] options.services.maddy.config.default;
      };
        
      systemd.services.maddy.serviceConfig.EnvironmentFile = config.sops.templates."maddy.env".path;

      sops.templates."maddy.env" = {
        content = ''
          MADDY_BREVO_SMTP_PASSWORD=${config.sops.placeholder."maddy_brevo_smtp_password"}
        '';
        owner = "maddy";
      };

      networking.firewall.allowedTCPPorts = [ 25 587 143 993 465 ];

      services.go-autoconfig = {
        enable = true;
        settings = {
          service_addr = ":1323";
          domain = "autoconfig.${config.domains.public}";
          imap = {
            server = main_domain;
            port = 993;
          };
          smtp = {
            server = main_domain;
            port = 587;
          };
        };
      };

      web_services."autoconfig" = {
        domains = "public";
        root = {
          proxyPass = "http://127.0.0.1:1323";
        };
      };
    };
}
