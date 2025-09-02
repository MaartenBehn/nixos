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
    "static:::4114:7e5a:3499:9a58"
    "eui64"
  ];
}
