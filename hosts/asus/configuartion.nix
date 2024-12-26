{ ... }:
{
  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell
    ../../configurations/syncthing.nix

    ../../configurations/kde.nix

  ];
}
