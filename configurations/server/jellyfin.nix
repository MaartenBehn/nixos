{ domains, local_domain, ... }:
{
  services.jellyfin.enable = true;
  networking.firewall.allowedUDPPorts = [ 7359 8096 ];
  # Client Discovery (7359/UDP): Allows clients to discover Jellyfin on the local network. A broadcast message to this port will return detailed information about your server that includes name, ip-address and ID.
  
  networking.firewall.allowedTCPPorts = [ 8096 ];
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "media.${domain}"; 
    value = { 
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8096/";
        proxyWebsockets = true;
      };

      serverAliases = [
        "www.media.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));


  services.homepage-dashboard = { 
    services = [
      {
        Media = [
          {
            Jellyfin = {
              #icon: "img."
              href = "http://media.home";
              description = "Media Server";
              widget = {
                type = "jellyfin";
                url = "http://media.home";
                key = "cca46e527a534e758a9cd74c398079e3";
                enableBlocks = true;
                enableNowPlaying = true;
                enableUser = true;
                enableMediaControl = true;
                showEpisodeNumber = true;
                expandOneStreamToTwoRows = true;
              };
            };
          }
        ];
      }
    ];
  };
}
