{ pkgs, domains, local_domain, ... }: {
  systemd.services.filebrowser = {
    path = with pkgs; [
      filebrowser
      getent
    ];
    script = "filebrowser --address 127.0.0.1 --database /home/stroby/filebrowser.db";
    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "files.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8080/"; 
      };

      serverAliases = [
        "www.files.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));

  services.homepage-dashboard = { 
    services = [
      {
        Data = [
          {
            FileBrowser = {
              href = "https://code.home/?tkn=voZ2d5c7o7lJ6l4C7FDqoaOcWVo2QGzvyf6&folder=/home/stroby/dev";
            };
          }
        ];
      }
    ];
  };
}


