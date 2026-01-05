{ local_domain, ... }: {
  services.mosquitto = {
    enable = true;
    listeners = [{
      address = "0.0.0.0";
      port = 1883;
      users.stroby = {
        acl = [
          "readwrite #"
        ];
        password = "mqtt+240803";
      };  
    }];  
  };

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 1883 ];
  };

  web_services."mqtt" = {
    domains = "local";
    loc = {
      proxyPass = "http://127.0.0.1:1883/";
      proxyWebsockets = true;
    };
  };
}
