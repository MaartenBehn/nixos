{ pkgs, ... }:

{
  networking.hostName = "desktop";

  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix

    ../../configurations/kde.nix
    ../../configurations/syncthing.nix
    ../../configurations/steam.nix
    ../../configurations/minecraft.nix 
  ];
  
  environment.systemPackages = with pkgs; [
    discord
    obsidian
  ];
}
