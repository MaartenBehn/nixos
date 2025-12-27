{ ... }: {
  services.nginx.virtualHosts."stroby.org" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      
    };

    serverAliases = [
      "www.stroby.org"
    ];
  };
}
