{ lib, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.concatStrings [ 
      (builtins.readFile ./init.fish) 
    ''
      starship init fish | source
    ''];
  };   
}
