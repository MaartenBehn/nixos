{ host, ... }: {
  imports = [
    # Base
    ./nix_stuff.nix
    ./local.nix
    ./user.nix
    ./clean.nix
    ./sops.nix
  ] 
    ++ (if host == "laptop" then
      [
        ../hardware-configuration.nix
        
        # Drivers
        ./bootloader.nix
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./networking.nix
        ./networking.nix
        ./audio.nix
        ./printing.nix
        ./bluetooh.nix
        ./fingerprint.nix
        ./usb_auto_mount.nix
        ./battery.nix

        # Windows
        ./window_manager

        # Apps
        ./syncthing.nix
        ./wireguard.nix
        ./mullvad_gui.nix

        # Gaming
        ./steam.nix
        ./lutris.nix

        # Other
        ./server/debug_tools.nix 
        ./server/hotspot.nix 

        #./filebrowser.nix
        ./set_kitty_default.nix

        ./server/algo_trading.nix
        ./virtualbox.nix

        ./smb.nix

      ] else [])
    ++ (if host == "desktop" then
      [
        ../hardware-configuration.nix
        
        # Drivers
        ./bootloader.nix
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./networking.nix
        ./nvidia.nix
        ./networking.nix
        ./audio.nix
        ./printing.nix
        ./usb_auto_mount.nix
        ./fix_stuck_on_tpmrm0.nix
        ./sops.nix

        # Windows
        ./window_manager

        # Apps
        ./syncthing.nix
        ./wireguard.nix

        # Gaming
        ./steam.nix
        ./mullvad_gui.nix

      ] else [])
    ++ (if host == "iso" then
      [
        ./iso.nix
        
        # Drivers
        ./bootloader.nix
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
        ./fix_stuck_on_tpmrm0.nix
        ./battery.nix

        # Windows
        ./window_manager

        #./calamares.nix
      ] else [])
    ++ (if host == "asus" then
      [
        ../hardware-configuration.nix
        
        # Drivers
        ./bootloader.nix
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./battery.nix
        ./keep_on_with_closed_lid.nix
        ./wireguard.nix
        
        ./server        
      ] else [])
    ++ (if host == "wsl" then
      [
        # Drivers
        ./wsl.nix
        ./networking.nix
      ] else []);
}
