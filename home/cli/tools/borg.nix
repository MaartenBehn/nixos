{ pkgs, ... }: 
let 
  borg_mount_fritz_behn_notes = pkgs.writeShellScriptBin "borg_mount_fritz_behn_notes" (''
    mkdir -p +/NotesBackupFritzBehns
    borgfs -p ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server ~/NotesBackupFritzBehns
  '');

in {
  home.packages = (with pkgs; [
    borgbackup
    borg_mount_fritz_behn_notes
  ]);

}
