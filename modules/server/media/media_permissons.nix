{
  flake.modules.nixos.server = {
    systemd.tmpfiles.rules = [
      # Recursively set ownership (stroby:media) and mode 2775
      "Z /media 2775 stroby media - -"

      # Set Access ACL recursively so the media group gets rwx on all current items
      "A+ /media - - - - group:media:rwx"

      # Set Default ACL so all future files/directories inherit group:media:rwx permissions
      "a+ /media - - - - group:media:rwx"
    ];
  };
}
