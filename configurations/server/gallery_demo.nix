{ domains, local_domain, ... }:
{ 

  users.groups.notes.members = [ "nginx" "syncthing" ];
 
  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "gallery.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        root = "/srv/gallery";
        extraConfig = '' 
          try_files $uri $uri.html /index.html =404;
        '';
      };

      serverAliases = [
        "www.gallery.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
