{ username, ... }:

{
  networking.hostName = "${username}-laptop";
  
  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/user.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix

    ../../configurations/kde.nix
    ../../configurations/development_programs.nix
    ../../configurations/apps.nix
    ../../configurations/syncthing.nix
    ../../configurations/wireguard.nix


    # ../../configurations/nextcloud.nix
    ../../configurations/server/debug_tools.nix
    
    ../../configurations/server/filebrowser.nix 
  ];
}
