{ local_domain, ... }: {
  services.jellyseerr = {
    enable = true;
    port = 5055;
  };

  services.nginx.virtualHosts = {

    "jellyseerr.${local_domain}" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:5055/"; 
      };

      serverAliases = [
        "www.jellyseerr.${local_domain}"
      ];
    };
  };
} 
