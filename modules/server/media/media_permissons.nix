{
  flake.modules.nixos.server = {
    systemd.tmpfiles.rules = [
      # Recursively set ownership (stroby:media) and mode 2770
      "Z /media 2770 stroby media - -"

      # Set Access ACL recursively so the media group gets rwx on all current items
      "A+ /media - - - - group:media:rwx"

      # Set Default ACL so all future files/directories inherit group:media:rwx permissions
      "a+ /media - - - - group:media:rwx"
    ];
  };
}
