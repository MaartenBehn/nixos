{
  flake.modules.nixos.hyprland = {
    services.udisks2.enable = true;
    programs.gnome-disks.enable = true;
  };
}
