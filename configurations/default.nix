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
        ./display_manager.nix
        ./window_manager

        # Apps
        ./syncthing.nix
        ./wireguard.nix
        ./mullvad_gui.nix

        # Gaming
        ./steam.nix

        # Other
        ./server/debug_tools.nix 
        ./server/hotspot.nix 

        # Eden
        ./dlr_eden_postgress.nix
        ./docker.nix


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
        ./display_manager.nix
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
        ./display_manager.nix
        ./window_manager

        #./calamares.nix
      ] else [])
    ++ (if host == "asus" then
      [
        ../hardware-configuration.nix
        
        # Drive
        ./bootloader.nix
        ./graphics.nix
        ./monitor_cpu_temp.nix
        ./battery.nix
        ./keep_on_with_closed_lid.nix
        ./wireguard.nix
        ./server/data_drive.nix

        # Server
        ./server/network.nix
        ./server/duckdns.nix
        ./server/blocky.nix
        ./server/ipv64.nix
        ./server/homepage.nix
        ./server/syncthing.nix
        ./server/vscode_server.nix
        ./server/filebrowser.nix
        ./server/minecraft.nix
        ./server/jellyfin.nix
        ./server/gallery_demo.nix 
        ./server/qbittorrnt.nix
        ./server/obsidian_export.nix
        ./server/home_assistant.nix
        ./server/actual_budget.nix
        ./server/notes.nix
        ./server/immich.nix
        ./server/nextcloud.nix
        ./server/baikal.nix
        
      ] else [])
    ++ (if host == "wsl" then
      [
        # Drive
        ./wsl.nix
        ./networking.nix
      ] else []);
}
