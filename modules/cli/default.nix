{
  flake.modules.homeManager.cli = { pkgs, ... }: {
    home.packages = (with pkgs; [ 
      ## CLI utility
      file                              # Show file information 
      hexdump
      openssl
      wavemon                           # monitoring for wireless network devices
      wget
      unzip
      speedtest-cli

      eza
      fd
      ripgrep                           # grep replacement
      dust                              # better du 
    ]);

    home.shellAliases = {
      ls = "exa -l -a --group";
      ping = "ping -c 5";

      grep = "rg";
      disk-usage = "sudo dust /";
    };
  };

  flake.modules.homeManager.full-cli = { pkgs, ... }: {
    home.packages = (with pkgs; [ 
      ## CLI utility
      ffmpeg
      jq                                # JSON processor
      libnotify                         # notify-send used to send desktop notifications
      yt-dlp-light                      # Youtube
      tdf                               # cli pdf viewer
      ncspot                            # Neo curses Spotify    

      ## Fun CLI 
      cbonsai                           # terminal screensaver
      cmatrix
      pipes                             # terminal screensaver

      nftables

      python313Packages.markitdown

      lego
    ]);
  };
}
