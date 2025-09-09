# Include this and not the default.nix if you only want to include light weight cli config

{ ... }:
{
  imports = [
    ./tools/minimal.nix
    ./fish.nix
    ./starship.nix
    
    ./nix.nix
    ./nixvim.nix

    ./ssh.nix   
    ./git.nix
  ];
}
