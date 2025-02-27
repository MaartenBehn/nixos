{ ... }:
{
  # SSL 
  security.acme = {
    acceptTerms = true;
    defaults.email = "stroby241@gmail.com";
  };
  
  # Open http and https ports
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # Websites
  services.nginx.virtualHosts = let
    SSL = {
      enableACME = true;
      forceSSL = true;
    }; in {
      "files.stroby.duckdns.org" = (SSL // {
        locations."/".proxyPass = "http://127.0.0.1:8080/";

        serverAliases = [
          "www.files.stroby.duckdns.org"
        ];
      });

      "syncthing.stroby.duckdns.org" = (SSL // {
        locations."/".proxyPass = "http://127.0.0.1:8384/";

        serverAliases = [
          "www.syncthing.stroby.duckdns.org"
        ];
      });

      "code.stroby.duckdns.org" = (SSL // {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8081/";
          proxyWebsockets = true;
        };

        serverAliases = [
          "www.code.stroby.duckdns.org"
        ];
      });

    /*
      "notes.stroby.duckdns.org" = (SSL // {
        locations."/" = {
          proxyPass = "http://127.0.0.1:8082/";
        };

        serverAliases = [
          "www.notes.stroby.duckdns.org"
        ];
      });
    */


    };
}
