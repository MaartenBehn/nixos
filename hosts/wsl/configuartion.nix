{ ... }:

{
  
  imports = [
    # Base 
    ../../configurations/bootloader.nix
    ../../configurations/nix_stuff.nix
    ../../configurations/local.nix
    ../../configurations/user.nix
    ../../configurations/clean.nix
    
    # Drivers
    ../../configurations/wsl.nix
    ../../configurations/networking.nix
   
    # Shell
    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix
  ];
}
