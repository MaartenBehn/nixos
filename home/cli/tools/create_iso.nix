{ pkgs, ... }: {
  home.packages = (with pkgs; [
    caligula                          # User-friendly, lightweight TUI for disk imaging
    ventoy                            # USD multi iso boot
  ]);
  
  home.shellAliases = { 
    iso-find-drive="sudo fdisk -l";
    find-drive="sudo fdisk -l";
  };

  programs.fish.functions = {
    iso-write-to-drive = {
      body = ''
        du -BM $argv[2]
        sudo dd bs=4M if=$argv[2] of=/dev/$argv[1] status=progress oflag=sync
      '';
      description = "iso-write-to-drive <sdx> <.iso file>";
    };
  };
}
