{ host, nix-version, ... }: {
  imports = (if host == "laptop" then
      [
        ./scripts/scripts.nix                   
        ./driver/solaar.nix
        ./programming_languages
        ./cli
      ] else [])
    ++ (if host == "desktop" then
      [  
        ./hyprland 
        ./scripts/scripts.nix        
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
        ./apps/beets
      ] else [])
    ++ (if host == "wsl" then
      [
        ./cli/tmux.nix
      ] else []);

}
