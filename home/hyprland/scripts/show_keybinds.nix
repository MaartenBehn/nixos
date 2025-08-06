{ pkgs, ... }: 
let 
  script = pkgs.writeShellScriptBin "show-keybinds" ''
#!/usr/bin/env bash

config_file=~/.config/hypr/hyprland.conf
keybinds=$(grep -oP '(?<=bind=).*' $config_file)
keybinds=$(echo "$keybinds" | sed 's/,\([^,]*\)$/ = \1/' | sed 's/, exec//g' | sed 's/^,//g')
rofi -dmenu -theme-str 'window {width: 50%;} listview {columns: 1;}' <<< "$keybinds"
  '';

 in {
  imports = [ ../rofi.nix ];
  
  home.packages = (with pkgs; [
    script
  ]);
}
