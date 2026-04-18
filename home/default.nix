{ host, nix-version, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = nix-version;

  home.username = "stroby";
  home.homeDirectory = "/home/stroby";

  imports = (if host == "laptop" then
      [
        ./hyprland 
        ./scripts/scripts.nix                   
        ./apps
        ./driver/solaar.nix
        ./programming_languages
        ./apps/minecraft.nix
        ./cli
      ] else [])
    ++ (if host == "desktop" then
      [  
        ./hyprland 
        ./scripts/scripts.nix        
        ./apps
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
        ./apps/beets
      ] else [])
    ++ (if host == "wsl" then
      [
        ./cli/minimal.nix
        ./cli/tmux.nix
      ] else []);

}
