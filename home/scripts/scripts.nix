{ pkgs, host, ... }:
let
  mkScript = name: pkgs.writeShellScriptBin "${name}" (
    builtins.readFile ./${name}.sh
  ); 
in
{
  home.packages = (map mkScript [
    "update_nix_index"
    
    "runbg"
    "music"
    "lofi"

    "maxfetch"

    "compress"
    "extract"

    "ascii"

    "record"

    "screenshot"

    "after_install"
  ]
  ++ (if host == "iso" then [
    "make_install_partitions"
    "install_config"
  ] else []))
  ++ [
    pkgs.zenity                            # Gui Dialogs (used in scripts)
    pkgs.tesseract
  ];
}
