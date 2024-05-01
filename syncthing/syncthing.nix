
{ pkgs, ... }:

{
  imports = [
    ./group.nix
    ./folders.nix
  ];

  environment.systemPackages = with pkgs; [
    syncthing
  ];

  services.syncthing.enable = true;
  networking.firewall.allowedTCPPorts = [ 8384 22000 ];
  networking.firewall.allowedUDPPorts = [ 22000 21027 ];
}
