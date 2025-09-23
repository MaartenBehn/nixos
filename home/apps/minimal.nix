# Include this and not the default.nix if you only want to essesntial apps

{ pkgs, ... }: {
  imports = [
    ./nemo.nix
 ];

  home.packages = (with pkgs; [
    firefox
    gnome-disk-utility # sudo -E gnome-disks for it to work
 ]);
}
