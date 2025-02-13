{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    firefox
    thunderbird
    obsidian
    discord
    vlc
    webcamoid
    spotify
    signal-desktop
    gimp
    obs-studio
    telegram-desktop
  ];
}
