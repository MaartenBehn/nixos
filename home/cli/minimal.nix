{ ... }:
{
  imports = [
    ./tools/minimal.nix
    ./fish.nix
    ./starship.nix
    
    ./nix.nix
    ./nixvim.nix

    ./ssh.nix   
    ./man.nix
    ./git.nix
  ];
}
