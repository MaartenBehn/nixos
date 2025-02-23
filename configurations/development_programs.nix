{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # dev
    python3
    gittyup
    lazygit

    # editor
    kate
    jetbrains.clion
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate
    jetbrains.rust-rover

    # wine
    wineWowPackages.stable
    winetricks
  ];
}
