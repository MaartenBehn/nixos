{ pkgs, local_domain, lib, ... }: 
let 
env_file = pkgs.writeTextFile {
    name = "slskd_env";
    text = ''
#SLSKD_SLSK_USERNAME=Stroby241
#SLSKD_SLSK_PASSWORD=SoulSeek+240803
SLSKD_USERNAME=Stroby241
SLSKD_PASSWORD=SoulSeek+240803
    '';
  };
in {
  services.slskd = { 
    enable = true;
    openFirewall = false;
    domain = "slskd.${local_domain}";
    environmentFile = env_file;
    settings = {
      directories = {
        incomplete = "/media/downloads/temp/soulseek";
        downloads = "/media/downloads/soulseek";
        uploads = "/media/upload/soulseek";
      };
      shares = {
        directories = []; 
      };

      global = {
        upload = {
          slots = 20;
        };
        download = {
          slots = 500;
          speed_limit = 1000;
        };
      };

            
      soulseek = {
        username = "Stroby241";
        password = "SoulSeek+240803";
      };

      web = {
        #port = 5030;
        #url_base = http://slskd.home;
        authentication = {
          disabled = false;
          apiKeys = {
            lidarr = {
              key = "nuewbginjie5623vh";
            };
          };
        };
      };
    };
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
