{
  flake.modules.nixos.iso = { pkgs, ... }: {

    ## Needs to the on sytem level otherwse it does not find the settings.conf file and the nixos module
    environment.systemPackages = with pkgs; [
      # Calamares for graphical installation
      libsForQt5.kpmcore
      calamares-nixos
      #calamares-nixos-autostart
      calamares-nixos-extensions
      # Get list of locales
      glibcLocales
      os-prober
    ];
  };

  flake.modules.homeManager.iso = { pkgs, config, ... }: {

    home.file."/home/${config.username}/.config/calamares/qml" = {
      source = "${pkgs.calamares}/share/calamares/qml";
      recursive = true;
    };

    home.file."/home/${config.username}/.config/calamares/branding" = {
      source = "${pkgs.calamares-nixos-extensions}/share/calamares/branding";
      recursive = true;
    };

    home.file."/home/${config.username}/.config/calamares/modules" = {
      source = "${pkgs.calamares-nixos-extensions}/share/calamares/modules";
      recursive = true;
    };

    home.file."/home/${config.username}/.config/calamares/settings.conf" = {
      source = "${pkgs.calamares-nixos-extensions}/share/calamares/settings.conf";
      recursive = true;
    }; 
  };
}
