{ inputs, domains, local_domain, config, pkgs, ... }: 
let 
  all_domains = domains ++ [ local_domain ];
  main_domain = "stroby.ipv64.de";
in {
  sops.secrets."mail/asus/pw" = { owner = "maddy"; };

  services.maddy = {
    enable = true;
    primaryDomain = main_domain;
    ensureAccounts = [
      "asus@${main_domain}"
    ];
    ensureCredentials = {
      #"asus@${main_domain}".passwordFile = config.sops.secrets."mail/asus/pw".path;
       "asus@${main_domain}".passwordFile = "${pkgs.writeText "asus" "test"}";
    };
  };

  networking.firewall.allowedTCPPorts = [ 25 587 143 ];
  networking.firewall.allowedUDPPorts = [ 25 587 143 ];
}
