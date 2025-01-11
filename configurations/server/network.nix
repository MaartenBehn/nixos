{ pkgs, ... }:
{
  imports = [
    ./ssh.nix
    ./static_ip.nix
  ];
  
  networking.networkmanager.enable = true;
}
