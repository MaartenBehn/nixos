{ pkgs, ... }: {
  imports = [
    ./hyprland_minimal.nix
    ./cava.nix
    ./gonme-text-editor.nix
    ./obsidian.nix
    # ./thunderbird.nix
    ./viewnior.nix
 ];

  home.packages = (with pkgs; [
    # default apps 
    mpv                               # simple video player
    evince                            # simple pdf viewer
    imv                               # simple image viewer

    xdg-utils

    # GUI Apps
    vlc                               # video player 
    libreoffice
    
    webcamoid
    obs-studio
    
    spotify
    signal-desktop
    obs-studio
    telegram-desktop
    discord
    
    filezilla        
    gimp                              # image editing
    pitivi                            # video editing
    audacity                          # Audio editing
    
    bleachbit                         # cache cleaner
    gnome-calculator                  # calculator
    
    winetricks
    wineWowPackages.wayland
 ]);
}
