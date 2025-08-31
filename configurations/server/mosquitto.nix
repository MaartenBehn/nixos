{ local_domain, ... }: {
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];
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
