{ domains, ... }: {
  services.dnsmasq = {
    enable = true;
    alwaysKeepRunning = true;
    settings = {
      interface="enp3s0f3u1";
      listen-address = [ "127.0.0.1" ];
      no-resolv = true;
      no-hosts = true;
      server = [ 
        "1.1.1.1" 
        "8.8.8.8" 
      ];
      address = (builtins.map (domain: "/${domain}/192.168.172.2") domains) ++ [
        "/fritz.box/192.168.172.1"
      ];
      expand-hosts = true;
    };
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
}
