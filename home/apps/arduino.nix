{ pkgs, ... }: {
  home.packages = (with pkgs; [ arduino ]);
}
