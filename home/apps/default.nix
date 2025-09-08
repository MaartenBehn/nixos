{ pkgs, ... }: {
  imports = [
    ./minimal.nix
    ./cava.nix
    ./gonme-text-editor.nix
    ./obsidian.nix
    ./thunderbird.nix
    ./unity.nix
    ./blender.nix
    ./blender.nix
    ./wine.nix
 ];

  home.packages = (with pkgs; [
    # default apps 
    mpv                               # simple video player
    evince                            # simple pdf viewer
    imv                               # simple image viewer
    f3d                               # simple 3d model viewer

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
   
    # For .exe files
    winetricks
    wineWowPackages.wayland
 ]);
}
