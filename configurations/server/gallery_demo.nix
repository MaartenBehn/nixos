{ domains, ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/Gallery/Build";
    listen = "127.0.0.1:8084";
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "gallery.${domain}"; 
    value = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8084/"; 
      };

      serverAliases = [
        "www.gallery.${domain}"
      ];
    };
  }) domains);

  containers.public-nginx.config = {
    
    services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
      name = "gallery.${domain}"; 
      value = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:8084/"; 
        };

        serverAliases = [
          "www.gallery.${domain}"
        ];
      };
    }) domains);
  };
}
