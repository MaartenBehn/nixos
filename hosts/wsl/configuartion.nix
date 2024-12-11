{ ... }:

{
  imports = [
    ../../configurations/base.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/fish.nix
    ../../configurations/nixvim.nix
  ];
}
