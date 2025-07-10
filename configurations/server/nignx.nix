{ ... }:
{
  # SSL 
  security.acme = {
    acceptTerms = true;
    defaults.email = "stroby241@gmail.com";
  };
  
  # Open http and https ports
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # Websites
  services.nginx.virtualHosts = let
    SSL = {
      enableACME = true;
      forceSSL = true;
    }; in {
    "files.stroby.duckdns.org" = (SSL // {
      locations."/".proxyPass = "http://127.0.0.1:8080/";

      serverAliases = [
        "www.files.stroby.duckdns.org"
      ];
    });

    "syncthing.stroby.duckdns.org" = (SSL // {
      locations."/".proxyPass = "http://127.0.0.1:8384/";

      serverAliases = [
        "www.syncthing.stroby.duckdns.org"
      ];
    });

    "code.stroby.duckdns.org" = (SSL // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8081/";
        proxyWebsockets = true;
      };

      serverAliases = [
        "www.code.stroby.duckdns.org"
      ];
    });

    "notes.stroby.duckdns.org" = (SSL // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8082/";
      };

      serverAliases = [
        "www.notes.stroby.duckdns.org"
      ];
    });

    "media.stroby.duckdns.org" = (SSL // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;
        
        recommendedGzipSettings = false;
        recommendedOptimisation = false;
        recommendedProxySettings = false;
        recommendedTlsSettings = false;

        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;

          # Disable buffering when the nginx proxy gets very resource heavy upon streaming
          proxy_buffering off; 
        '';
      };

      locations."/socket" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;

        recommendedGzipSettings = false;
        recommendedOptimisation = false;
        recommendedProxySettings = false;
        recommendedTlsSettings = false;

        extraConfig = ''
          proxy_http_version 1.1;
          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection "upgrade";
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;
        '';
      };

      serverAliases = [
        "www.media.stroby.duckdns.org"
      ];

          });
 
    "qbittorrent.stroby.duckdns.org" = (SSL // {
      locations."/" = {
        proxyPass = "http://192.168.15.1:8083/"; 
      };

      serverAliases = [
        "www.qbittorrent.stroby.duckdns.org"
      ];
    });

    "jackett.stroby.duckdns.org" = (SSL // {
      locations."/" = {
        proxyPass = "http://192.168.15.1:9117/"; 
      };

      serverAliases = [
        "www.jackett.stroby.duckdns.org"
      ];
    });

    "flaresolverr.stroby.duckdns.org" = (SSL // {
      locations."/" = {
        proxyPass = "http://192.168.15.1:8191/"; 
      };

      serverAliases = [
        "www.jackett.stroby.duckdns.org"
      ];
    });
  };
}
