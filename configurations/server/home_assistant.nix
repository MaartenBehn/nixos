{ local_domain, ... }: {
  mports = [
    ./mosquitto.nix
  ];

  services.home-assistant = {
    enable = true;
    extraComponents = [
      # Components required to complete the onboarding
      "esphome"
      "met"
      "radio_browser"
      "google_translate"
      "tasmota"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = {};

      http = {
        # For extra security set this to only accept connections on localhost if NGINX is on the same machine
        # Uncommenting this will mean that you can only reach Home Assistant using the proxy, not directly via IP from other clients.
        server_host = "127.0.0.1";
        use_x_forwarded_for = true;
        # You must set the trusted proxy IP address so that Home Assistant will properly accept connections
        # Set this to your NGINX machine IP, or localhost if hosted on the same machine.
        trusted_proxies = "127.0.0.1";
      };
    };
  };

  services.nginx.virtualHosts."home.${local_domain}" = {  
    enableACME = false;
    forceSSL = false;

    locations."/" = {
      proxyPass = "http://127.0.0.1:8123/";
      proxyWebsockets = true;
      #extraConfig = ''
      #  proxy_set_header    Upgrade     $http_upgrade;
      #   proxy_set_header    Connection  "upgrade";
      #'';
    };

    serverAliases = [
      "www.home.${local_domain}"
    ];
  };
}
