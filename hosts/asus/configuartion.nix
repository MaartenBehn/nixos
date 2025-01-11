{ pkgs, ... }:
{
  networking.hostName = "asus";

  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix

    ../../configurations/syncthing.nix

    ../../configurations/server/dynv6dns.nix
    ../../configurations/server/duckdns.nix
    ../../configurations/server/static_ip.nix
    ../../configurations/server/network.nix
    ../../configurations/server/nextcloud.nix
   
    ../../configurations/server/minecraft_server.nix
  ]; 

  services.logind.lidSwitch = "ignore";
}
