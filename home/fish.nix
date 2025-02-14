{ lib, ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = lib.concatStrings [ 
      (builtins.readFile ./init.fish) 
    ''
      if status is-interactive
      and not set -q TMUX
          exec tmux new -As0
      end

      starship init fish | source
    ''];
  };   
}
