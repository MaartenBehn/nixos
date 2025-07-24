{ domain, ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/Gallery/Build";
    listen = "127.0.0.1:8084";
  };

  services.nginx.virtualHosts = let
    SSL = {
      enableACME = true;
      forceSSL = true;
    }; in {
 
    "gallery.${domain}" = (SSL // {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8084/"; 
      };

      serverAliases = [
        "www.gallery.${domain}"
      ];
    });
  };
}
