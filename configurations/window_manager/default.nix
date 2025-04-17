{ desktop , ...}: {
  imports = if desktop == "hyprland" then  
    [ ./hyprland.nix ]
  else
    [ ./kde.nix ];
}
