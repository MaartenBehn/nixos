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

  services.nginx.enable = true;
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
        locations."/".proxyPass = "http://127.0.0.1:8081/";

        serverAliases = [
          "www.code.stroby.duckdns.org"
        ];
      });

    };
}
