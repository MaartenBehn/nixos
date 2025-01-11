{ pkgs, ... }:

{
  networking.hostName = "desktop";

  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell

    ../../configurations/kde.nix
    ../../configurations/syncthing.nix
    ../../configurations/steam.nix
    ../../configurations/minecraft.nix

    ../../configurations/server/minecraft_server.nix
    ../../configurations/server/dynv6dns.nix
    ../../configurations/server/duckdns.nix
    ../../configurations/server/static_ip.nix
  ];
  
  environment.systemPackages = with pkgs; [
    discord
    obsidian
  ];
}
