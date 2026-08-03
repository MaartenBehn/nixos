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

    services.dnsmasq = {
      enable = true;
      settings = {
        interface = [ "enp3s0f3u1" ];
        dhcp-range = [ "192.168.100.10,192.168.100.100,12h" ];
      };
    };

    networking.firewall = {
      enable = true;

      checkReversePath = false;

      allowedUDPPorts = [ 53 67 ];
      allowedTCPPorts = [ 53 ];

      extraInputRules = ''
        iifname "enp3s0f3u1" accept
      '';
      extraForwardRules = ''
        iifname "enp3s0f3u1" oifname "wlp1s0" accept
        iifname "wlp1s0" oifname "enp3s0f3u1" ct state established,related accept
      '';
    };  
  };
}
