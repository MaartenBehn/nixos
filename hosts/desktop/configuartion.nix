{ ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/kde.nix
    ../../configurations/nixvim.nix
    ../../configurations/fish.nix
    # ../../configurations/docker.nix
    ../../configurations/syncthing.nix
    ../../configurations/steam.nix

    ../../configurations/for_isec.nix
  ];
}
