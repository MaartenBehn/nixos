{ domains, ... }: {
  networking.nameservers = [ "127.0.0.1" ];

  containers.public-nginx.config = {
    services.dnsmasq = {
      enable = true;
      alwaysKeepRunning = true;
      settings = {
        server = [ 
          "1.1.1.1" 
          "8.8.8.8" 
        ];
        address = (builtins.map (domain: "/${domain}/192.168.172.3") domains) ++ [
          "/fritz.box/192.168.172.1"
        ];
      };
    };
    networking.firewall.allowedTCPPorts = [ 53 ];
  };
}
