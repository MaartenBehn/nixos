{
  flake.modules.nixos.share_network = {
    boot.kernel.sysctl = {
      # "net.ipv4.ip_forward" = 1; 
      # Allready set by vpm namespace
    };

    networking.nftables.enable = true;

    networking.interfaces."enp3s0f3u1" = {
      useDHCP = false;
      ipv4.addresses = [{
        address = "192.168.100.1";
        prefixLength = 24;
      }];
    };

    networking.nat = {
      enable = true;
      enableIPv6 = false;
      internalInterfaces = [ "enp3s0f3u1" ];
      externalInterface = "wlp1s0";
    };

    networking.firewall.checkReversePath = false;

    services.dnsmasq = {
      enable = true;
      settings = {
        interface = [ "enp3s0f3u1" ];
        dhcp-range = [ "192.168.100.10,192.168.100.100,12h" ];
      };
    };

    networking.firewall.allowedUDPPorts = [ 53 67 ];
    networking.firewall.allowedTCPPorts = [ 53 ]; 
  };
}
