{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    bitwarden-desktop
    seahorse
  ];
  services.gnome.gnome-keyring.enable = true;
}
