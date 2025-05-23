{ host, ... }: {
  imports = [
    # Base
    ./bootloader.nix
    ./nix_stuff.nix
    ./local.nix
    ./user.nix
    ./clean.nix
  ] 
    ++ (if host == "laptop" then
      [
    ../hardware-configuration.nix
        ./battery.nix
        
        # Drivers
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./networking.nix
        ./networking.nix
        ./audio.nix
        ./printing.nix
        ./bluetooh.nix
        ./fingerprint.nix
        ./usb_auto_mount.nix

        # Windows
        ./display_manager.nix
        ./window_manager

        # Apps
        ./syncthing.nix
        ./wireguard.nix

        # Gaming
        ./steam.nix

        # Other
        ./server/debug_tools.nix 
        ./server/hotspot.nix 
      ] else [])
    ++ (if host == "desktop" then
      [
        ../hardware-configuration.nix
        # Drivers
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./networking.nix
        ./nvidia.nix
        ./networking.nix
        ./audio.nix
        ./printing.nix
        ./usb_auto_mount.nix
        ./dual_boot.nix

        # Windows
        ./display_manager.nix
        ./window_manager

        # Apps
        ./syncthing.nix
        ./wireguard.nix

        # Gaming
        ./steam.nix

      ] else [])
    ++ (if host == "iso" then
      [
        ./iso.nix
        ./battery.nix
        
        # Drivers
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./networking.nix
        ./nvidia.nix
        ./networking.nix
        ./audio.nix
        ./printing.nix
        ./bluetooh.nix
        ./fingerprint.nix
        ./logitech.nix
        ./usb_auto_mount.nix

        # Windows
        ./display_manager.nix
        ./window_manager
      ] else [])
    ++ (if host == "asus" then
      [
    ../hardware-configuration.nix
        # Drive
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./networking.nix

        # Server
        ./server/duckdns.nix
        ./server/static_ip.nix
        ./server/network.nix
        ./server/syncthing.nix
        ./server/obsidian_export.nix
        ./server/vscode_server.nix
        ./server/filebrowser.nix
        ./server/minecraft.nix
      ] else [])
    ++ (if host == "wsl" then
      [
        # Drive
        ./wsl.nix
        ./networking.nix
      ] else []);


  # Desktop fix
  #   systemd.tpm2.enable = false;
}
