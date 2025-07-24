{ ... }: {
  networking.nameservers = [ "127.0.0.1" ];

  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      server = [ 
        "1.1.1.1" 
        "8.8.8.8" 
      ];
      address = [
        "/stroby.ipv64.de/192.168.172.21"
        "/fritz.box/192.168.172.1"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
}
