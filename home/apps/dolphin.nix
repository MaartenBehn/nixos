{ pkgs, ... }: {
  home.packages = (with pkgs; [
    dolphin
    kdePackages.qtsvg
  ]);
}
