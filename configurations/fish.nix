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
  ];

  users.defaultUserShell = pkgs.fish;
  programs.command-not-found.enable = false;
  programs.nix-index.enable = true;

  environment.variables = {
    PKG_CONFIG_PATH = with pkgs; lib.makeLibraryPath [
      fontconfig
    ];
    EDITOR = "nano";
    TARGET = target;
  };


  # programs.neovim.enable = true;
}
