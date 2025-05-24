{ pkgs, ... }: {
  imports = [
    ./nemo.nix
    #./dolphin.nix
 ];

  home.packages = (with pkgs; [
    firefox
    gnome-disk-utility # sudo -E gnome-disks for it to work
 ]);
}
