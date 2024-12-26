{ ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell

    ../../configurations/kde.nix
    ../../configurations/development_programs.nix
    ../../configurations/apps.nix
    ../../configurations/syncthing.nix
    ../../configurations/wireguard.nix


    ../../configurations/for_isec.nix
  ];
}
