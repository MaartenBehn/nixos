{
  flake.modules.homeManager.hyprland = { pkgs, config, ... }:
    let 
      wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" ''
        hyprctl dispatch 'hl.dsp.exec_cmd("waypaper", { float = true; size = "925 615" })'
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
          echo "/home/${config.username}/nixos/assets/wallpapers/nixos.png"
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
          awww img --transition-type="wipe" --transition-angle=135 $1 &
        else
          awww img --transition-type="$random_animation" $1 &
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
        folder = ~/nixos/assets/wallpapers
        monitors = All
        wallpaper = ~/nixos/assets/wallpapers/nixos.png
        backend = awww
        fill = fill
        sort = name
        color = #ffffff
        subfolders = False
        show_hidden = False
        show_gifs_only = False
        post_command = pkill .waypaper-wrapp && save-wallpaper-for-layout $wallpaper
        number_of_columns = 3
        awww_transition_type = any
        awww_transition_step = 90
        awww_transition_angle = 0
        awww_transition_duration = 2
        awww_transition_fps = 60
        use_xdg_state = False
      '';
    };
}
