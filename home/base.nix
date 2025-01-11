{ ... }:
{
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
 
  # Base Nix tools
  programs.nix-index.enable = true;
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
