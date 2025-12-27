{ config, options, pkgs, ... }: 
let 
  main_domain = "stroby.org";
in {

  sops.secrets."mail/admin/pw" = { owner = "maddy"; };

  services.maddy = {
    enable = true;
    openFirewall = true;
    primaryDomain = main_domain;
    ensureAccounts = [
      "admin@${main_domain}"
    ];
    ensureCredentials = {
      "admin@${main_domain}".passwordFile = config.sops.secrets."mail/admin/pw".path;
    };

    tls = {
      loader = "file";
      certificates = [{
          keyPath = "/var/lib/acme/mx.stroby.org/key.pem";
          certPath = "/var/lib/acme/mx.stroby.org/cert.pem";
      }];
    };

    # Enable TLS listeners. Configuring this via the module is not yet
    # implemented, see https://github.com/NixOS/nixpkgs/pull/153372
    config = builtins.replaceStrings [
      "imap tcp://0.0.0.0:143"
      "submission tcp://0.0.0.0:587"
    ] [
        "imap tls://0.0.0.0:993 tcp://0.0.0.0:143"
        "submission tls://0.0.0.0:465 tcp://0.0.0.0:587"
      ] options.services.maddy.config.default;
  };

  security.acme = {
    acceptTerms = true;
    certs."mx.stroby.org" = {
      dnsProvider = "cloudflare";
      environmentFile = "${config.sops.templates."maddy_acme.env".path}";
      group = config.services.maddy.group;
    };
  };

  sops.secrets.maddy_cloudflare_api = { 
    key = "cloudflare/acme/api_token";
  };
  sops.templates."maddy_acme.env" = {
    content = ''
       CLOUDFLARE_DNS_API_TOKEN='${config.sops.placeholder.maddy_cloudflare_api}'
    '';
  };
 
  networking.firewall.allowedTCPPorts = [ 25 587 143 993 465 ];
  networking.firewall.allowedUDPPorts = [ 25 587 143 993 465 ];

  services.go-autoconfig = {
    enable = true;
    settings = {
      service_addr = ":1323";
      domain = "autoconfig.stroby.org";
      imap = {
        server = "stroby.org";
        port = 993;
      };
      smtp = {
        server = "stroby.org";
        port = 587;
      };
    };
  };

  services.nginx.virtualHosts."autoconfig.stroby.org" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:1323";
    };

    serverAliases = [
      "www.autoconfig.stroby.org"
    ];
  };
}
