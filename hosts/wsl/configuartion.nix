{ ... }:

{
  networking.hostName = "wsl";
  
  imports = [
    ../../configurations/nix_stuff.nix
    ../../configurations/local.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix
  ];
}
