{ pkgs, ... }: {
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

}
