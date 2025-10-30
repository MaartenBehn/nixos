# Include this and not the default.nix if you only want to include light weight essesntial cli tools

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
}
