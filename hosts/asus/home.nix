{ ... }:
{
  imports = [
    ../../home/base.nix
    ../../home/stroby.nix
    ../../home/fish.nix
    ../../home/alacritty.nix
  ];

  programs.alacritty.settings.font.size = 7;
}
