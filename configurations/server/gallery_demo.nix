{ domains, local_domain, ... }:
{
  services.static-web-server = {
    enable = true;
    root = "/home/stroby/dev/3d_gallery/build";
    listen = "127.0.0.1:8084";
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "gallery.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8084/"; 
      };

      serverAliases = [
        "www.gallery.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
