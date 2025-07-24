{ domains, ... }: {
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      server = [ 
        "1.1.1.1" 
        "8.8.8.8"
        "2606:4700:4700::64"
      ];
      address = (builtins.map (domain: "/${domain}/192.168.172.2") domains) ++
        (builtins.map (domain: "/${domain}/2a00:1f:ef04:7301:3e59:650b:4c40:f405") domains) ++ [
        "/fritz.box/192.168.172.1"
      ];
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
}
