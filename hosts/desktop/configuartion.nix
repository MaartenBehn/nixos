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
    ../../configurations/minecraft_server.nix
    ../../configurations/dynv6dns.nix
    ../../configurations/duckdns.nix
  ];
  
  environment.systemPackages = with pkgs; [
    discord
    obsidian
  ];
}
