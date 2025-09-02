{ system_name, ... }:
{
  imports = [
    ./ssh.nix
    ./nignx.nix
  ];

  networking = {
    hostName = system_name;

    firewall.enable = true;
 
    networkmanager.enable = false;
    tempAddresses = "disabled";

    interfaces.enp3s0f3u1 = {
      macAddress = "01:01:01:01:01:01";
    };
  };

  #systemd.network.networks."enp3s0f3u1".ipv6AcceptRAConfig.Token = [
  #  "static:::1111:1111:1111:1111"
  #  "eui64"
  #];
} 
