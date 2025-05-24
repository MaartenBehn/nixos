{ desktop, username, host, nix-version, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = nix-version;

  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = 
  (if desktop == "hyprland" then 
    [ 
      ./hyprland 
      ./scripts/scripts.nix             # personal scripts
      ./apps/hyprland_minimal.nix
    ] else [ ])
  ++ (if desktop == "hyprland" && host != "iso" then 
    [ 
      ./apps/hyprland_apps.nix
    ] else [ ])
  ++ (if desktop == "plasma" then 
    [ 
      ./plasma/plasma.nix 
    ] else [ ])


  ++ (if host == "laptop" then
    [
      ./driver/solaar.nix
      ./programming_languages/all.nix
      ./cli
    ] else [])
  ++ (if host == "desktop" then
    [
      ./driver/solaar.nix
      #./programming_languages/all.nix
      ./cli
    ] else [])
  ++ (if host == "iso" then
    [
        ./cli/minimal.nix
        ./cli/terminal
        ./cli/tmux.nix
    ] else [])
  ++ (if host == "asus" then
    [
      ./cli/minimal.nix
    ] else [])
    ++ (if host == "wsl" then
      [
      ./cli/minimal.nix
      ] else []);

}
