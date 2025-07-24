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
      ];
    };
    extraConfig = ''
      interface=enp3s0f3u1
      
      # DNS
      listen-address=1,127.0.0.1
      # It listens on both the local and the bridge interface.
      expand-hosts
      # This will allow you to refer to devices by their hostname.
    '';
  };
  networking.firewall.allowedTCPPorts = [ 53 ];
}
