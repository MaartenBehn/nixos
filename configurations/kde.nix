{ pkgs, inputs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.libinput.enable = true;
  services.displayManager.sddm.enable = true;

  # services.desktopManager.plasma6.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "";
  };

  # Fonts
  # https://nixos.wiki/wiki/Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs;[
      noto-fonts-cjk   # Beautiful and free fonts for CJK languages
      noto-fonts-emoji # Color and Black-and-White emoji fonts
      nerdfonts
    ];
  };

  environment.systemPackages = with pkgs; [
    # System Tools
    kdePackages.partitionmanager
    qdirstat

    # Shell
    yakuake

    # Netowork stuff
    gnirehtet
    android-tools # needed for gnirehtet
    openconnect
    networkmanager
    libreswan

    # Apps
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

    # dev
    python3
    gittyup

    # editor
    kate
    jetbrains.clion
    jetbrains.webstorm
    jetbrains.pycharm-professional
    jetbrains.idea-ultimate
    jetbrains.rust-rover
    sublime
    zed-editor

    inputs.nixvim.packages.x86_64-linux.default
    xclip
    lazygit

    # wine
    wineWowPackages.stable
    winetricks

    rust-analyzer

    synology-drive-client

    gnupg
  ];
}
