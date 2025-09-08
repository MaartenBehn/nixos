{ pkgs, ... }: {
  imports = [
    ./minimal.nix
    ./create_iso.nix
    ./create_wsl.nix
    ./presenterm.nix
  ];

  home.packages = (with pkgs; [
    
    ## CLI utility
    ffmpeg
    jq                                # JSON processor
    libnotify                         # notify-send used to send desktop notifications
    yt-dlp-light                      # Youtube
    tdf                               # cli pdf viewer
    yazi
    ncspot                            # Neo curses Spotify    
     
    ## Fun CLI 
    cbonsai                           # terminal screensaver
    cmatrix
    pipes                             # terminal screensaver

    nftables

    python313Packages.markitdown
    docling
  ]);
}
