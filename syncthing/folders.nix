
{ pkgs, config, ... }:

let
  user = "stroby";
  folders = {
    "Notes" = {
      id = "text";
      path = "/home/${user}/Notes";
      ignorePerms = true;
    };
  };

  inherit (builtins) map attrValues;
in
{
  imports = [ ../task.nix ];

  systemd.tmpfiles.rules = (map (folder: "d ${folder.path} 2770 ${user} syncthing") (attrValues folders));

   
  tasks.fix-syncthing-permissions = {
    user = "stroby";
    onCalendar = "*-*-* 18:00:00";
    script = let
      folders = pkgs.lib.concatMapStringsSep " " (folder: folder.path) (builtins.attrValues config.services.syncthing.settings.folders);
      in ''
        for FOLDER in ${folders}; do
          find "$FOLDER" -type f \( ! -group syncthing -or ! -perm -g=rw \) -not -path "*/.st*" -exec chgrp syncthing {} \; -exec chmod g+rw {} \;
          find "$FOLDER" -type d \( ! -group syncthing -or ! -perm -g=rwxs \) -not -path "*/.st*" -exec chgrp syncthing {} \; -exec chmod g+rwxs {} \;
        done
      '';
  };

}
