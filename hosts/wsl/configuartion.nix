{ ... }:

{
  imports = [
    ../../configurations/base.nix
    ../../configurations/clean.nix
    ./drivers.nix

    .../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix
  ];
  networking.hostName = "wsl";
}
