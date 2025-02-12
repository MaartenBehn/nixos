{ pkgs, ... }:
{
  networking.hostName = "asus";

  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/stroby.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix

    ##../../configurations/server/dynv6dns.nix
    ../../configurations/server/duckdns.nix
    ../../configurations/server/static_ip.nix
    ../../configurations/server/network.nix
    ../../configurations/server/syncthing.nix

    #../../configurations/server/nextcloud.nix
    ../../configurations/server/vscode_server.nix
    ../../configurations/server/filebrowser.nix
   
    ../../configurations/server/minecraft.nix
    ##../../configurations/server/terraria.nix
 
    ../../configurations/shell/tmux.nix
    ../../configurations/kde.nix
    ../../configurations/apps.nix
    ../../configurations/virtualbox.nix
    
    ../../configurations/minecraft.nix
  ]; 

  services.logind.lidSwitch = "ignore";
}
