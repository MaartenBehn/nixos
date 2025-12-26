{ config, options, ... }: 
let 
  main_domain = "stroby.org";
in {
  sops.secrets."mail/admin/pw" = { owner = "maddy"; };

  services.maddy = {
    enable = true;
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
        host ${config.services.maddy.primaryDomain}
        challenge dns-01
        dns gandi {
          api_token "{env:GANDI_API_KEY}"
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
    secrets = [ config.sops.templates."maddy_secrets.env".path ];
  };

  sops.templates."maddy_secrets.env" = {
    content = ''
       GANDI_API_KEY='${config.sops.placeholder."mail/gandi_api_key"}'
    '';
    owner = "maddy";
  };

  networking.firewall.allowedTCPPorts = [ 25 587 143 993 465 ];
  networking.firewall.allowedUDPPorts = [ 25 587 143 993 465 ];
}
