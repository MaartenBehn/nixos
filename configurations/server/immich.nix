{ domains, local_domain, ... }: {
  services.immich = {
    enable = true;
    port = 2283;
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "immich.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;
      locations."/" = {
        proxyPass = "http://127.0.0.1:2283/"; 
      };

      serverAliases = [
        "www.immich.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ]));
}
