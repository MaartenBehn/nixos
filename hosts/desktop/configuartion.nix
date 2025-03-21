{ username, ... }:

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
    ../../configurations/nvidia.nix
    ../../configurations/monitor_cpu_temp.nix
    ../../configurations/networking.nix
    ../../configurations/bluetooh.nix
    ../../configurations/audio.nix
    ../../configurations/printing.nix

    # Windows
    ../../configurations/display_manager.nix
    ../../configurations/hyperland.nix

    # Apps
    ../../configurations/syncthing.nix
    ../../configurations/wireguard.nix

    # Gaming
    ../../configurations/steam.nix
    ../../configurations/minecraft.nix 
  ];

  # Bug fixes
  ## Timeout fix
  systemd.tpm2.enable = false;
}
