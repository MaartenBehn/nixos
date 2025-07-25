{ domains, ... }:
{
  services.jellyfin.enable = true;
  networking.firewall.allowedUDPPorts = [ 7359 8096 ];
  # Client Discovery (7359/UDP): Allows clients to discover Jellyfin on the local network. A broadcast message to this port will return detailed information about your server that includes name, ip-address and ID.
  
  networking.firewall.allowedTCPPorts = [ 8096 ];
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "media.${domain}"; 
    value = { 
      enableACME = true;
      forceSSL = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;
        
        recommendedProxySettings = false;

        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Real-IP $remote_addr;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Forwarded-Protocol $scheme;
          proxy_set_header X-Forwarded-Host $http_host;

          proxy_set_header Upgrade $http_upgrade;
          proxy_set_header Connection $http_connection;

          # Disable buffering when the nginx proxy gets very resource heavy upon streaming
          proxy_buffering off; 
        '';
      };

      locations."/socket" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;

        recommendedProxySettings = false;

        extraConfig = ''
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
        "www.media.${domain}"
      ];
    };
  }) domains);
}
