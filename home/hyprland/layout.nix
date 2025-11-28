{ pkgs, ... }:
let 
  current-layout = pkgs.writeShellScriptBin "current-layout" ''
    mkdir -p ~/.config/layout/
    cd ~/.config/layout/
    if [ ! -f "current_layout" ]; then
      echo "home"
    else 
      cat current_layout
    fi
  '';

  set-layout = pkgs.writeShellScriptBin "set-layout" ''
    if [ $# -eq 0 ]; then
      echo "No layout arg"
      exit
    fi

    set-monitors $1
    wallpaper="$(wallpaper-for-layout $1)"
    set-wallpaper $wallpaper

    mkdir -p ~/.config/layout/
    cd ~/.config/layout/
    echo "$1" > "current_layout"
  '';
 
  restore-layout = pkgs.writeShellScriptBin "restore-layout" ''
    layout="$(current-layout)"
    set-monitors $layout
    
    wallpaper="$(wallpaper-for-layout $layout)"
    set-wallpaper $wallpaper
  '';

  guess-layout = pkgs.writeShellScriptBin "guess-layout" ''
    network="$(nmcli -c no)"

    if [[ $network == *"DLR Gastzugang"* ]]; then
      set-layout "dlr"
      exit
    fi

    set-layout "home"
  '';

  set-monitors = pkgs.writeShellScriptBin "set-monitors" (
    builtins.readFile ./scripts/set-monitors.sh
  );

in {
  home.packages = [ 
    current-layout
    set-layout
    set-monitors
    restore-layout
    guess-layout
  ];
}
