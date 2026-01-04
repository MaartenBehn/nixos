{ lib, ... }:
{
  imports = [ ./nignx_web_service.nix ];

  config = {
    # SSL 
    security.acme = {
      acceptTerms = true;
      defaults.email = "admin@stroby.org";
    };

    # Open http and https ports
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
    networking.firewall.allowedUDPPorts = [
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

  };
}
