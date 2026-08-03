{
  flake.modules.nixos.server = {
    systemd.tmpfiles.rules = [
      # Recursively set ownership (stroby:media) and mode 2750
      "Z /notes 2750 syncthing notes - -"

      # Set Access ACL recursively so the media group gets r-x on all current items
      "A+ /notes - - - - group:notes:r-x"

      # Set Default ACL so all future files/directories inherit group:media:r-x permissions
      "a+ /notes - - - - group:notes:r-x"
    ];
  };
}
