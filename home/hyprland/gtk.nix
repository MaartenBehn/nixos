{ pkgs, ... }:
let
  monolisa = pkgs.callPackage ../../pkgs/monolisa/monolisa.nix { };
  monolisa-nerd = pkgs.callPackage ../../pkgs/monolisa/monolisa-nerd.nix {
    inherit monolisa;
  };
in
{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    jetbrains-mono
    fira-code
    nerd-fonts.caskaydia-cove
    nerd-fonts.symbols-only
    twemoji-color-font
    noto-fonts-emoji
    fantasque-sans-mono
    # maple-mono
    # monolisa
    # monolisa-nerd
  ];

  gtk = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 12;
    };
    theme = {
      name = "Colloid-Green-Dark-Gruvbox";
      package = pkgs.colloid-gtk-theme.override {
        colorVariants = [ "dark" ];
        themeVariants = [ "green" ];
        tweaks = [
          "gruvbox"
          "rimless"
          "float"
        ];
      };
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme.override { color = "black"; };
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 24;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };
}
