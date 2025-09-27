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
        ./apps/minimal.nix
      ] else [ ])
    ++ (if desktop == "hyprland" && host != "iso" then 
      [ 
        ./apps
      ] else [ ])
    ++ (if desktop == "plasma" then 
      [ 
        ./plasma/plasma.nix 
      ] else [ ])


    ++ (if host == "laptop" then
      [
        ./driver/solaar.nix
        ./programming_languages
        ./cli
      ] else [])
    ++ (if host == "desktop" then
      [
        ./driver/solaar.nix
        ./apps/minecraft.nix
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
        ./cli/tmux.nix
      ] else [])
    ++ (if host == "wsl" then
      [
        ./cli/minimal.nix
        ./cli/tmux.nix
      ] else []);

}
