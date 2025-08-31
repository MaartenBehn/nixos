{ local_domain, ... }: {
  services.mosquitto = {
    enable = true;
    listeners = [{
      address = "127.0.0.1";
      port = 1883;
      users.tasmota = {
        acl = [
          "pattern readwrite #"
        ];
        password = "mqtt+240803";
      };  
    }];  
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1883 ];
  };

  services.nginx.virtualHosts."mqtt.${local_domain}" = {  
    enableACME = false;
    forceSSL = false;

    locations."/" = {
      proxyPass = "http://127.0.0.1:1883/";
      proxyWebsockets = true;
    };

    serverAliases = [
      "www.mqtt.${local_domain}"
    ];
  };
}
