{ ... }:
{
  imports = [
    # Base
    ../../hardware-configuration.nix
    ../../configurations/bootloader.nix
    ../../configurations/nix_stuff.nix
    ../../configurations/local.nix
    ../../configurations/user.nix
    ../../configurations/clean.nix
    
    # Drivers
    ../../configurations/graphics.nix
    ../../configurations/monitor_cpu_temp.nix
    ../../configurations/networking.nix

    # Shell
    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix
   
    # Server
    ../../configurations/server/duckdns.nix
    ../../configurations/server/static_ip.nix
    ../../configurations/server/network.nix
    ../../configurations/server/syncthing.nix
    ../../configurations/server/obsidian_export.nix
    ../../configurations/server/vscode_server.nix
    ../../configurations/server/filebrowser.nix
    ../../configurations/server/minecraft.nix
  ]; 

  services.logind.lidSwitch = "ignore";
}
