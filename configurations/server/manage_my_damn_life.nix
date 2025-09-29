{ inputs, domains, local_domain, ... }: 
let manage-my-damn-life = inputs.manage-my-damn-life.packages.x86_64-linux.default; 
in {

  systemd.services.manage-my-damn-life = {
    script = "${manage-my-damn-life}";
    environment = {
      PORT = 8045;
    };

    wantedBy = [ "network-online.target" ];
		after = [ "network.target" ];
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "calendar.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8045/"; 
      };

      serverAliases = [
        "www.calendar.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
