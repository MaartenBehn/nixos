{ username, ... }:

{
  networking.hostName = "${username}-laptop";
  
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
    ../../configurations/networking.nix
    ../../configurations/monitor_cpu_temp.nix
    ../../configurations/networking.nix
    ../../configurations/bluetooh.nix
    ../../configurations/audio.nix
    ../../configurations/printing.nix
    ../../configurations/fingerprint.nix
    
    # Shell
    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix

    # Windows
    ../../configurations/display_manager.nix
    #../../configurations/kde.nix
    ../../configurations/hyperland.nix

    # Apps
    #../../configurations/development_programs.nix
    #../../configurations/apps.nix
    ../../configurations/syncthing.nix
    ../../configurations/wireguard.nix

    # Other
    ../../configurations/server/debug_tools.nix 
  ];
}
