{ inputs, domains, local_domain, config, ... }: 
let 
  all_domains = domains ++ [ local_domain ];
  main_domain = "stroby.ipv64.de";
in {
  imports = [
    inputs.mailserver.mailserverModule
  ];

  sops.secrets."mail/asus/hash" = { owner = "mailserver"; };

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.${main_domain}";
    domains = all_domains;

    # To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "asus@${main_domain}" = {
        hashedPasswordFile = config.sops.secrets."ipv64/key".path;
        # aliases = ["postmaster@example.com"];
      };
    };

    certificateScheme = "acme-nginx";
  };
}
