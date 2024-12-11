{ ... }:

{
  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ./drivers.nix

    ../../configurations/fish.nix
    ../../configurations/nixvim.nix
  ];
}
