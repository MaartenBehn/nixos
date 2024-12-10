{ ... }:
{
  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ./drivers.nix

    ../../configurations/kde.nix
    ../../configurations/fish.nix
    # ../../configurations/docker.nix
    ../../configurations/syncthing.nix

    ../../configurations/for_isec.nix
  ];
}

