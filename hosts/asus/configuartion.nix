{ pkgs, ... }:
{
  networking.hostName = "asus";

  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell
    ../../configurations/syncthing.nix
    ../../configurations/wireguard.nix

    ../../configurations/server/dynv6dns.nix
    ../../configurations/server/duckdns.nix
    ../../configurations/server/static_ip.nix
    ../../configurations/server/debug_tools.nix
    ../../configurations/server/ssh.nix
   
    ../../configurations/server/minecraft_server.nix
  ]; 
}
