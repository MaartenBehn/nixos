{ pkgs, ... }: {
  imports = [
    ./bat.nix                         # better cat command
    ./btop.nix                        # resouces monitor 
    ./fastfetch.nix                   # fetch tool
    ./fzf.nix                         # fuzzy finder
    ./lazygit.nix
  ];

  home.packages = (with pkgs; [ 
    ## CLI utility
    file                              # Show file information 
    hexdump
    ncdu                              # disk space
    openssl
    wavemon                           # monitoring for wireless network devices
    wget
    unzip
    speedtest-cli
    
    eza
    gtrash                            # rm replacement, put deleted files in system trash
    fd
    ripgrep                           # grep replacement
    dust                              # better du 
  ]);

  home.shellAliases = {
    ls = "exa -l -a";
    ping = "ping -c 5";

    #rm = "gtrash put";
    grep = "rg";
    disk-usage = "ncdu /";
  };
}
