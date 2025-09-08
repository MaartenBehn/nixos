{ pkgs, ... }: {
  imports = [
    ./nemo.nix
 ];

  home.packages = (with pkgs; [
    firefox
    gnome-disk-utility # sudo -E gnome-disks for it to work
 ]);
}
