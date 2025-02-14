{ pkgs, modulesPath, ... }: {

  networking.hostName = "iso";
  
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-graphical-calamares.nix"
    
    ../../configurations/base.nix
    ../../configurations/clean.nix
    ../../configurations/stroby.nix

    ../../configurations/shell/fish.nix
    ../../configurations/shell/nixvim.nix
    ../../configurations/shell/tmux.nix
    ../../configurations/kde.nix
  ];

  isoImage.edition = "plasma5";

  nixpkgs.hostPlatform = "x86_64-linux"; 

  services.displayManager.autoLogin = {
    enable = true;
    user = "stroby";
  };

  system.activationScripts.installerDesktop =
    let

      # Comes from documentation.nix when xserver and nixos.enable are true.
      manualDesktopFile = "/run/current-system/sw/share/applications/nixos-manual.desktop";

      homeDir = "/home/stroby/";
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
