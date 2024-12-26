{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Apps
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
