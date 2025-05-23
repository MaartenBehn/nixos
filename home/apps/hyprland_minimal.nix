{ pkgs, ... }: {
  imports = [
    ./nemo.nix
 ];

  home.packages = (with pkgs; [
    firefox
 ]);
}
