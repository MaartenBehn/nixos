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

    ../../configurations/kde.nix 
    ../../configurations/server/debug_tools.nix
  ];

  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
