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
    ../../configurations/bluetooh.nix
    ../../configurations/audio.nix
    ../../configurations/printing.nix
    ../../configurations/fingerprint.nix
     
    # Windows
    ../../configurations/display_manager.nix
    ../../configurations/window_manager

    # Apps
    ../../configurations/syncthing.nix
    ../../configurations/wireguard.nix

    # Other
    ../../configurations/server/debug_tools.nix 
    ../../configurations/server/hotspot.nix 
    #../../configurations/server/kuka_horizon_dev.nix 
    
    ../../configurations/steam.nix
  ];
}
