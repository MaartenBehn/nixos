{ pkgs, username, ... }: {
  
  home.file."/home/${username}/.config/calamares/qml" = {
    source = "${pkgs.calamares}/share/calamares/qml";
    recursive = true;
  };

  home.file."/home/${username}/.config/calamares/branding" = {
    source = "${pkgs.calamares-nixos-extensions}/share/calamares/branding";
    recursive = true;
  };

  home.file."/home/${username}/.config/calamares/modules" = {
    source = "${pkgs.calamares-nixos-extensions}/share/calamares/modules";
    recursive = true;
  };

  home.file."/home/${username}/.config/calamares/settings.conf" = {
    source = "${pkgs.calamares-nixos-extensions}/share/calamares/settings.conf";
    recursive = true;
  }; 
}
