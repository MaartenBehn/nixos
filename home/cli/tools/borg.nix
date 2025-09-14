{ pkgs, ... }: 
let 
  borg_mount_fritz_behn_notes = pkgs.writeShellScriptBin "borg_mount_fritz_behn_notes" (''
    mkdir -p ~/NotesBackupFritzBehns
    borgfs -p ssh://Stroby@192.168.178.39/volume1/BackUp/asus_server ~/NotesBackupFritzBehns
  '');

  borg_mount_proxy_notes = pkgs.writeShellScriptBin "borg_mount_proxy_notes" (''
    mkdir -p ~/NotesBackupProxy
    borgfs -p ssh://root@138.199.203.38/backup/notes ~/NotesBackupProxy
  '');


in {
  home.packages = (with pkgs; [
    borgbackup
    borg_mount_fritz_behn_notes
    borg_mount_proxy_notes
  ]);

}
