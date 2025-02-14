{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./static_ip.nix
    ./nignx.nix
  ];
  
  networking.firewall.enable = true;
  networking.networkmanager.enable = true;
}
