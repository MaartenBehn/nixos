{ domains, local_domain, ... }: {
  services.kasmweb = { 
    enable = true;
    listenPort = 8087;
  };

  systemd.services.kasmweb = {
    vpnConfinement = {
      enable = false;
      vpnNamespace = "mullvad";
    };
  };

  vpnNamespaces.mullvad = {
    portMappings = [
      { 
        from = 8087;
        to = 8087;
      }
    ];
  };

  services.nginx.virtualHosts = builtins.listToAttrs (builtins.map (domain: {
    name = "kasm.${domain}"; 
    value = {
      enableACME = domain != local_domain;
      forceSSL = domain != local_domain;

      locations."/" = {
        #proxyPass = "http://192.168.15.1:8087/"; 
        proxyPass = "https://127.0.0.1:8087/"; 
      };

      serverAliases = [
        "www.kasm.${domain}"
      ];
    };
  }) (domains ++ [ local_domain ])); 
}
