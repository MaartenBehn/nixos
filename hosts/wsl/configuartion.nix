{ ... }:

{
  imports = [
    ../../configurations/base.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell

  ];
  networking.hostName = "wsl";
}
