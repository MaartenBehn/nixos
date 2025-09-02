{ ... }:
{
  imports = [
    ./ssh.nix
    ./nignx.nix
  ];

  networking = {
    firewall.enable = true;
 
    networkmanager.enable = true;
    tempAddresses = "disabled";
  };

  systemd.network.networks."enp3s0f3u1".ipv6AcceptRAConfig.Token = [
    "static:::1111:1111:1111:1111"
    "eui64"
  ];
} 
