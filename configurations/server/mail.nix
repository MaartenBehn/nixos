{ config, options, ... }: 
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
      loader = "acme";
      extraConfig = ''
        email admin@stroby.org
        agreed # indicate your agreement with Let's Encrypt ToS
        hostname ${config.services.maddy.primaryDomain}
        challenge dns-01
        dns cloudflare {
          api_token "{env:CLOUDFLARE_API_TOKEN}"
        }
      '';
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
    # Reading secrets from a file. Do not use this example in production
    # since it stores the keys world-readable in the Nix store.
    secrets = [ "${config.sops.templates."maddy_secrets.env".path}" ];
  };

  sops.secrets.maddy_cloudflare_api = { 
    key = "cloudflare/acme/api_token";
    owner = "maddy"; 
  };
  sops.templates."maddy_secrets.env" = {
    content = ''
       CLOUDFLARE_API_TOKEN='${config.sops.placeholder.maddy_cloudflare_api}'
    '';
    owner = "maddy";
  };

  networking.firewall.allowedTCPPorts = [ 25 587 143 993 465 ];
  networking.firewall.allowedUDPPorts = [ 25 587 143 993 465 ];
}
