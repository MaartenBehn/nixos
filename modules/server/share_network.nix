{
  flake.modules.nixos.share_network = {
    boot.kernel.sysctl = {
      # "net.ipv4.ip_forward" = 1; 
      # Allready set by vpm namespace
    };

    networking.interfaces."eth0" = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.100.1";
        prefixLength = 24;
      }];
    };

    networking.nat = {
      enable = true;
      internalInterfaces = [ "eth0" ];
      externalInterface = "wlan0";
    };

    services.dnsmasq = {
      enable = true;
      settings = {
        interface = [ "eth0" ];
        dhcp-range = [ "192.168.100.10,192.168.100.100,12h" ];
      };
    };

    networking.firewall.allowedUDPPorts = [ 53 67 ];
    networking.firewall.allowedTCPPorts = [ 53 ]; 
  };
}
