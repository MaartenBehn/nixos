{ pkgs, ... }: 
let 
  wall-change = pkgs.writeShellScriptBin "wall-change" (
    builtins.readFile ./wall-change.sh
  );

  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" (
    builtins.readFile ./wallpaper-picker.sh
  ); 

  random-wallpaper = pkgs.writeShellScriptBin "random-wallpaper" (
    builtins.readFile ./random-wallpaper.sh
  );  
in {
  imports = [ ../rofi.nix ];

  home.packages = (with pkgs; [
    swww
    wall-change
    wallpaper-picker
    random-wallpaper
  ]);
}
