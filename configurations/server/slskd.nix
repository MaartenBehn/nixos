{ pkgs, local_domain, lib, ... }: 
let 
env_file = pkgs.writeTextFile {
    name = "slskd_env";
    text = ''
#SLSKD_SLSK_USERNAME = ;
#SLSKD_SLSK_PASSWORD = ;
SLSKD_USERNAME = Stroby241;
SLSKD_PASSWORD = SoulSeek+240803;
    '';
  };
in {
  services.slskd = { 
    enable = true;
    openFirewall = false;
    domain = "slskd.${local_domain}";
    environmentFile = env_file;
  };
  
  systemd.services.slskd = {
    vpnConfinement = {
      enable = true;
      vpnNamespace = "mullvad";
    };
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 5030;
        to = 5030;
      }
    ];
  };

  services.nginx.virtualHosts = {

    "slskd.${local_domain}" = {
      locations."/" = {
        proxyPass = lib.mkForce "http://192.168.15.1:5030/"; 
      };

      serverAliases = [
        "www.slskd.${local_domain}"
      ];
    };
  };
}
