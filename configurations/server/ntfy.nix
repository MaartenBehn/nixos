{ local_domain, domains, ... }: {
  services.ntfy-sh = {
    settings = {
      base-url = "ntfy.stroby.ipv64.de";
      listen-http = ":8081";
    };
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "ntfy.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8081/"; 
        proxyWebsockets = true;
      };

      serverAliases = [
        "www.ntfy.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));

}
