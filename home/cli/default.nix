{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # For uni VPN 
    openconnect
  
    # reverse thether to phone
    gnirehtet     
    android-tools # needed for gnirehtet

    vaultwarden

  ];  
  imports = [
    ./tools
    ./minimal.nix
    ./terminal
    ./tmux.nix
    #./man.nix
  ];
}
