{ lib, ... }:
{
  # SSL 
  security.acme = {
    acceptTerms = true;
    defaults.email = "stroby241@gmail.com";
  };
  
  # Open http and https ports
  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  services.nginx = {
    enable = false;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  # To be able to ping containers from the host, it is necessary
  # to create a macvlan on the host on the VLAN 1 network.
  networking.macvlans.mv-eth1-host = {
    interface = "enp3s0f3u1";
    mode = "bridge";
  };
  networking.interfaces.eth1.ipv4.addresses = lib.mkForce [];
  networking.interfaces.mv-eth1-host = {
    ipv4.addresses = [ { address = "192.168.178.3"; prefixLength = 24; } ];
  };

  containers.public = {
    autoStart = true;
    macvlans = [ "enp3s0f3u1" ];

    config = {
      networking.interfaces.mv-eth1 = {
        ipv4.addresses = [ { address = "192.168.178.254"; prefixLength = 24; } ];
      };

      # SSL 
      security.acme = {
        acceptTerms = true;
        defaults.email = "stroby241@gmail.com";
      };

      services.nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedOptimisation = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;
      };

    };
  };
}
