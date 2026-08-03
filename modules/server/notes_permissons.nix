{
  flake.modules.nixos.server = {
    systemd.tmpfiles.rules = [
      # Recursively set ownership (stroby:media) and mode 2750
      "Z /notes 2750 syncthing notes - -"

      # Set Access ACL recursively so the media group gets rwx on all current items
      "A+ /notes - - - - group:notes:rwx"

      # Set Default ACL so all future files/directories inherit group:media:rwx permissions
      "a+ /notes - - - - group:notes:rwx"
    ];
  };
}
