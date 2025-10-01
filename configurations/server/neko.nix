{ inputs, system, domains, local_domain, ... }: {

  users.users.neko = {
    isSystemUser = true;
    group = "neko";
  };

  systemd.services.neko-server = {
    script = "${inputs.neko.packages."${system}".server}";
    wantedBy = [ "network-online.target" ];
    serviceConfig.User = "neko";
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "calendar.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000/"; 
      };

      serverAliases = [
        "www.calendar.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
