{ inputs, pkgs, ... }: 
let 
  _2048 = pkgs.callPackage ../../pkgs/2048/default.nix {}; 
in
{
  home.packages = (with pkgs; [
    
    ## CLI utility
    caligula                          # User-friendly, lightweight TUI for disk imaging
    fd                                # find replacement
    ffmpeg
    file                              # Show file information 
    gtrash                            # rm replacement, put deleted files in system trash
    hexdump
    imv                               # image viewer
    jq                                # JSON processor
    libnotify                         # notify-send used to send desktop notifications
    
    man-pages                         # extra man pages
    tldr                              # Better man
    
    mpv                               # video player
    ncdu                              # disk space
    openssl
    poweralertd                       # Battery notifications    
    #upower                            # Needed for poweralertd

    nix-prefetch-github
    programmer-calculator             # to show bits of calculations (pcalc)
    ripgrep                           # grep replacement
    # shfmt                             # bash formatter
    swappy                            # snapshot editing tool
    tdf                               # cli pdf viewer
    unzip
    valgrind                          # c memory analyzer
    wavemon                           # monitoring for wireless network devices
    wl-clipboard                      # clipboard utils for wayland (wl-copy, wl-paste)
    wget
    woomer
    yt-dlp-light                      # Youtube
    xdg-utils
    # xxd

    ## CLI 
    cbonsai                           # terminal screensaver
    cmatrix
    pipes                             # terminal screensaver
    #sl
    # tty-clock                         # cli clock
    btop

    # Fetch tools
    onefetch                          # fetch utility for git repo

    # GUI Apps
    firefox
    vlc                               # video player 
    libreoffice
    
    webcamoid
    obs-studio
    
    spotify
    signal-desktop
    obs-studio
    telegram-desktop
    
    filezilla        
    gimp                              # image editing
    pitivi                            # video editing
    audacity                          # Audio editing
    
    gnome-disk-utility
    bleachbit                         # cache cleaner
    pavucontrol                       # pulseaudio volume controle (GUI)
    gnome-calculator                  # calculator
    # soundwireserver
    
    winetricks
    wineWowPackages.wayland
    zenity                            # Gui Dialogs (used in scripts) 
    
    # C / C++
    gcc
    gdb
    gnumake

    # Zig
    inputs.zig.packages.${system}.master
    zls

    # Python
    python3
    python312Packages.ipython

    # Nix tools
    # inputs.alejandra.defaultPackage.${system}
    # nitch                             # systhem fetch util
    # nixd                              # nix lsp
    # nixfmt-rfc-style                  # nix formatter

    #_2048
    # ani-cli                           # Anime Name
    # aoc-cli                           # Advent of Code command-line tool
    # binsider                          # static and dynamic analysis tools for ELF libaries
    # bitwise                           # cli tool for bit / hex manipulation
    # dconf-editor                      
    # docfd                             # TUI multiline fuzzy document finder
    # entr                              # perform action when file change
    # gtt                               # google translate TUI
    # gifsicle                          # gif utility
    # treefmt2                          # project formatter
    # todo                              # cli todo list
    # toipe                             # typing test in the terminal
    # ttyper                            # cli typing test
    # mimeo
    # pamixer                           # pulseaudio command line mixer
    # playerctl                         # controller for media players 
  ]);
}
