{ username, ... }:
{
  networking.hostName = "${username}-asus";

  imports = [
    ../../hardware-configuration.nix
    ../../configurations/base.nix
    ../../configurations/user.nix
    ../../configurations/clean.nix
    ./drivers.nix

    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix
    
    ../../configurations/server/duckdns.nix
    ../../configurations/server/static_ip.nix
    ../../configurations/server/network.nix
    ../../configurations/server/syncthing.nix
    ../../configurations/server/obsidian_export.nix

    ../../configurations/server/vscode_server.nix
    ../../configurations/server/filebrowser.nix
   
    ../../configurations/server/minecraft.nix
    ##../../configurations/server/terraria.nix
 
    #../../configurations/kde.nix
    #../../configurations/virtualbox.nix
    
    #../../configurations/minecraft.nix

    #../../configurations/for_isec.nix
  ]; 

  services.logind.lidSwitch = "ignore";
}
