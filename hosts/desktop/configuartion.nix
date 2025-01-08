{ pkgs, ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell

    ../../configurations/kde.nix
    # ../../configurations/docker.nix
    ../../configurations/syncthing.nix
    ../../configurations/steam.nix

    ../../configurations/for_isec.nix
  ];

  environment.systemPackages = with pkgs; [
    discord
    obsidian
  ];
}
