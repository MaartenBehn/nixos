{
  flake.modules.homeManager.apps-minimal = { pkgs, ... }: {
    home.packages = (with pkgs; [
      firefox
      gnome-disk-utility # sudo -E gnome-disks for it to work
    ]);
  };

  flake.modules.homeManager.apps = { pkgs, ... }: {
    home.packages = (with pkgs; [
      # default apps 
      mpv                               # simple video player
      evince                            # simple pdf viewer
      imv                               # simple image viewer
      f3d                               # simple 3d model viewer

      xdg-utils

      # GUI Apps
      #vlc                               # video player 
      #libreoffice
      onlyoffice-desktopeditors
      obsidian

      webcamoid
      #obs-studio

      #spotify
      #signal-desktop
      #obs-studio
      #telegram-desktop
      discord

      #filezilla        
      gimp                              # image editing
      #pitivi                            # video editing
      #audacity                          # Audio editing
      blender                          # 3d modling software
      kicad                            # schematic and bcd desinger

      #unityhub 
      #vscode
      #arduino

      bleachbit                         # cache cleaner
      qalculate-gtk

      #soulseekqt
      #webull-desktop

      ausweisapp
      zoom-us
      prismlauncher
    ]);
  };
}
