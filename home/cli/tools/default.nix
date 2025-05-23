{ pkgs, ... }: {
  imports = [
    ./minimal.nix
    ./create_iso.nix
  ];

  home.packages = (with pkgs; [
    
    ## CLI utility
    ffmpeg
    imv                               # image viewer
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
  ]);
}
