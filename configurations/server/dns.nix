{ domains, ... }: {
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      server = [ 
        "1.1.1.1" 
        "8.8.8.8" 
      ];
      address = (builtins.map (domain: "/${domain}/192.168.172.2") domains) ++ [
        "/fritz.box/192.168.172.1"
        "/media.stroby.ipv64.de/192.168.172.2"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
}
