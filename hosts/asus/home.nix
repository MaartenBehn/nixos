{ ... }:
{
  imports = [
    ../../home/base.nix
    ../../home/stroby.nix
    ../../home/fish.nix
    ../../home/git.nix
    ../../home/ssh.nix
    ../../home/alacritty.nix
  ];

  programs.alacritty.settings.font.size = 7;
}
