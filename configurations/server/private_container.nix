{ lib, pkgs, nix-version, ... }:
{ 
  # To be able to ping containers from the host, it is necessary
  # to create a macvlan on the host on the VLAN 1 network.
  networking.macvlans.mv-eth1-host = {
    interface = "enp3s0f3u1";
    mode = "bridge";
  };
  networking.interfaces.eth1.ipv4.addresses = lib.mkForce [];
  networking.interfaces.private-host = {
    ipv4.addresses = [ { address = "192.168.178.3"; prefixLength = 24; } ];
  };

  containers.private = {
    autoStart = true;
    macvlans = [ "enp3s0f3u1" ];

    config = {
      system.stateVersion = nix-version;

      imports = [
        ./qbittorrnt.nix
      ];

      environment.systemPackages = with pkgs; [
        btop 
      ];
      
      networking.interfaces.private-host = {
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
