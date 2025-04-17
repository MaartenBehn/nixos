{ desktop, ... }: {
  imports = if desktop == "hyprland" then 
    [ ./hyprland ]
  else 
    [ ./plasma.nix ];
}
