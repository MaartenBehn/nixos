{ local_domain, ... }: {
  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};
    };
  };

  networking.firewall.allowedTCPPorts = [ 8096 ];
  services.nginx.virtualHosts = {
    name = "home.${local_domain}"; 
    value = { 
      enableACME = false;
      forceSSL = false;

      locations."/" = {
        proxyPass = "http://127.0.0.1:8123/";
        #proxyWebsockets = true;
      };

      serverAliases = [
        "www.home.${local_domain}"
      ];
    };
  };
}
