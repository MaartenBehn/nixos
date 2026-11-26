/*
WG: 
Plug on: 192.168.0.45

mgtt config: 
host: 192.168.0.117
port: 1883
client: asus_plug
user: stroby
password: mqtt+240803
topic: asus_plug
full topic: %prefix%/%topic%/
*/

{
  flake.modules.nixos.server = {
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
      root = {
        proxyPass = "http://127.0.0.1:1883/";
        proxyWebsockets = true;
      };
    };
  };
}
