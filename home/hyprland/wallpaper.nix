{ pkgs, ... }:
let 
  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" ''
    hyprctl dispatch exec '[float; size 925 615] waypaper'
  ''; 

  save-wallpaper-for-layout = pkgs.writeShellScriptBin "save-wallpaper-for-layout" ''
    if [ $# -eq 0 ]; then
      echo "Post: no wallpaper arg"
      exit
    fi

    layout="$(current-layout)"
    mkdir -p ~/.config/layout/
    cd ~/.config/layout/
    echo "$1" > "$layout-wallpaper"
  '';

  wallpaper-for-layout = pkgs.writeShellScriptBin "wallpaper-for-layout" ''
    if [ $# -eq 0 ]; then
      echo "Give a layout name"
      exit
    fi

    file="$1-wallpaper"

    mkdir -p ~/.config/layout/
    cd ~/.config/layout/
    if [ ! -f $file ]; then
      echo "~/nixos/wallpapers/others/nixos.png"
    else 
      cat $file
    fi
  '';

  set-wallpaper = pkgs.writeShellScriptBin "set-wallpaper" ''
    if [ $# -eq 0 ]; then
      echo "Please give a path to a wallpaper file"
      exit
    fi

    animations=("outer" "center" "any" "wipe")
    random_animation=''${animations[RANDOM % ''${#animations[@]}]}

    if [[ "$random_animation" == "wipe" ]]; then
      swww img --transition-type="wipe" --transition-angle=135 $1 &
    else
      swww img --transition-type="$random_animation" $1 &
    fi  
  ''; 
in {
  home.packages = (with pkgs; [ 
    jq
    waypaper
    wallpaper-picker
    save-wallpaper-for-layout
    wallpaper-for-layout    
    set-wallpaper
  ]);

  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    language = en
    folder = ~/nixos/wallpapers/others
    monitors = All
    wallpaper = ~/nixos/wallpapers/others/nixos.png
    backend = swww
    fill = fill
    sort = name
    color = #ffffff
    subfolders = False
    show_hidden = False
    show_gifs_only = False
    post_command = pkill .waypaper-wrapp && save-wallpaper-for-layout $wallpaper
    number_of_columns = 3
    swww_transition_type = any
    swww_transition_step = 90
    swww_transition_angle = 0
    swww_transition_duration = 2
    swww_transition_fps = 60
    use_xdg_state = False
  '';
}
