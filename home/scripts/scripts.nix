{ pkgs, host, ... }:
let
  mkScript = name: pkgs.writeShellScriptBin "${name}" (
    builtins.readFile ./${name}.sh
  ); 
in
{
  home.packages = (map mkScript [
    "update_nix_index"
    "set-monitors"

    "trigger_ghostty_hyprland"
    "trigger_alacritty_hyprland"
    "trigger_kitty_hyprland"
    "trigger_alacritty_kde"
    "trigger_kitty_kde"

    "vpn_to_behns"
    
    "wall-change"
    "wallpaper-picker"
    "random-wallpaper"

    "runbg"
    "music"
    "lofi"

    "toggle_blur"
    "toggle_oppacity"
    "toggle_waybar"
    "toggle_float"

    "maxfetch"

    "compress"
    "extract"

    "show-keybinds"

    "vm-start"

    "ascii"

    "record"

    "screenshot"

    "rofi-power-menu"
    "power-menu"

    "after_install"
    "open_vim_cheat_sheet"
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
