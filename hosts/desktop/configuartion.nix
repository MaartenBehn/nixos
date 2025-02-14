{ pkgs, ... }:

{
  networking.hostName = "stroby-desktop";

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
    ../../configurations/wireguard.nix
    ../../configurations/steam.nix
    ../../configurations/minecraft.nix 
    ../../configurations/apps.nix 
  ]; 
}
