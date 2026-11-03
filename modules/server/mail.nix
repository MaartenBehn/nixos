{
  my.secrets.server."mail_admin_password" = { 
    bitwarden = { name = "Mail Admin"; field = "password"; };
    owner = "maddy"; 
  };

  my.secrets.server."maddy_brevo_smtp_password" = {
    bitwarden = { name = "Brevo"; field = "maddy_key"; };
    owner = "maddy";
  };

  my.secrets.server.acme_cloudflare_api = { 
    bitwarden = { name = "Cloudflare"; field = "asus_acme_token"; };
  };


  flake.modules.nixos.server = { config, options, pkgs, ... }: 
    let 
      main_domain = "mail.stroby.org";
    in {

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
            keyPath = "/var/lib/maddy/certs/key.pem";
            certPath = "/var/lib/maddy/certs/cert.pem";
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

      security.acme = {
        acceptTerms = true;
        certs."mail.stroby.org" = {
          dnsProvider = "cloudflare";
          email = "maarten.behn@gmail.com";
          environmentFile = config.sops.templates."acme.env".path;
          postRun = "mkdir -p /var/lib/maddy/certs && cp cert.pem /var/lib/maddy/certs/cert.pem && cp key.pem /var/lib/maddy/certs/key.pem && chown -R maddy:maddy /var/lib/maddy/certs";
        };
      };

      sops.templates."maddy.env" = {
        content = ''
          MADDY_BREVO_SMTP_PASSWORD=${config.sops.placeholder."maddy_brevo_smtp_password"}
        '';
        owner = "maddy";
      };

      sops.templates."acme.env" = {
        content = ''
          CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder.acme_cloudflare_api}
        '';
      };

      networking.firewall.allowedTCPPorts = [ 25 587 143 993 465 ];

      services.go-autoconfig = {
        enable = true;
        settings = {
          service_addr = ":1323";
          domain = "autoconfig.stroby.org";
          imap = {
            server = "mail.stroby.org";
            port = 993;
          };
          smtp = {
            server = "mail.stroby.org";
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
