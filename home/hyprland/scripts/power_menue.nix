{pkgs, ... }: 
let
  rofi-power-menu = pkgs.writeShellScriptBin "rofi-power-menu" (
    builtins.readFile ./rofi-power-menue.sh
  ); 

  script = pkgs.writeShellScriptBin "power-menu" ''
#!/usr/bin/env bash

rofi -show p -modi p:'rofi-power-menu' -theme-str 'window {width: 10em; height: 15em;} listview {lines: 5;}' 
  ''; 
in {
  imports = [ ../rofi.nix ];
  
  home.packages = (with pkgs; [
    rofi-power-menu
    script 
  ]);
}
