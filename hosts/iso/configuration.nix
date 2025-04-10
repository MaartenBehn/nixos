{ pkgs, modulesPath, username, system, ... }: {

  networking.hostName = "iso";
  
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"
       
    # Base
    ../../configurations/bootloader.nix
    ../../configurations/nix_stuff.nix
    ../../configurations/local.nix
    ../../configurations/user.nix
    ../../configurations/clean.nix

    # Drivers
    ../../configurations/graphics.nix
    ../../configurations/nvidia.nix
    ../../configurations/networking.nix
    ../../configurations/monitor_cpu_temp.nix
    ../../configurations/networking.nix
    ../../configurations/bluetooh.nix
    ../../configurations/audio.nix
  
    # Shell
    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix
    
    # OS
    ../../configurations/display_manager.nix
    ../../configurations/hyperland.nix

  ];

  isoImage.edition = "plasma5";

  nixpkgs.hostPlatform = system; 

  services.displayManager.autoLogin = {
    enable = true;
    user = username;
  };

  system.activationScripts.installerDesktop =
    let

      # Comes from documentation.nix when xserver and nixos.enable are true.
      manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

      homeDir = "/home/${username}/";
      desktopDir = homeDir + "Desktop/";

    in
    ''
      mkdir -p ${desktopDir}
      chown stroby ${homeDir} ${desktopDir}

      ln -sfT ${manualDesktopFile} ${desktopDir + "nixos-manual.desktop"}
      ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop ${desktopDir + "gparted.desktop"}
      ln -sfT ${pkgs.calamares-nixos}/share/applications/io.calamares.calamares.desktop ${
        desktopDir + "io.calamares.calamares.desktop"
      }
    '';
}
