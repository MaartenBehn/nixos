{ config, ... }: 
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
  };

  networking.firewall.allowedTCPPorts = [ 25 587 143 ];
  networking.firewall.allowedUDPPorts = [ 25 587 143 ];
}
