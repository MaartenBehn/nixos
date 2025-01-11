{ ... }:
{
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      source ~/nixos/home/init.fish

      starship init fish | source
    '';
  };   
}
