{ ... }:
{
  imports = [
    ../../home/base.nix
    ../../home/stroby.nix
    ../../home/fish.nix
    ../../home/git.nix
    ../../home/ssh.nix   
    ../../home/vscode.nix
    ../../home/alacritty.nix
    ../../home/plasma.nix
  ];

  #programs.alacritty.settings.font.size = 7;
}
