{ pkgs, target, ... }:
{
  programs.fish.enable = true;
  environment.systemPackages = with pkgs; [
    # shell env programms
    fish
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fzf
    fishPlugins.grc
    grc
    dwt1-shell-color-scripts
    starship
    direnv

    # shell programms
    eza
    btop
    git
    meld
    fd
    unzip
    wget
    killall

    # nix cli
    nix-index
    nix-du
    nix-search-cli

    # For uni VPN 
    openconnect

    # reverse thether to phone
    gnirehtet     
    android-tools # needed for gnirehtet

    neofetch
  ];

  users.defaultUserShell = pkgs.fish;
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  environment.variables = {
    PKG_CONFIG_PATH =
      with pkgs;
      lib.makeLibraryPath [
        fontconfig
      ];
    EDITOR = "nano";
    NIX_TARGET = target;
  };

  # Fonts
  # https://nixos.wiki/wiki/Fonts
  fonts = {
    fontDir.enable = true;
    packages = with pkgs; [
      noto-fonts-cjk # Beautiful and free fonts for CJK languages
      noto-fonts-emoji # Color and Black-and-White emoji fonts
      nerdfonts
    ];
  };

  # programs.neovim.enable = true;
}
