{
  flake.modules.homeManager.hyprland = {pkgs, ... }: 
    let
      rofi-power-menu = pkgs.writeShellScriptBin "rofi-power-menu" (
        builtins.readFile ./rofi-power-menue.sh
      ); 

      power-menu = pkgs.writeShellScriptBin "power-menu" ''
        rofi -show p -modi p:'rofi-power-menu' -theme-str 'window {width: 10em; height: 15em;} listview {lines: 5;}' 
      ''; 
    in {
      home.packages = [
        rofi-power-menu
        power-menu 
      ];
    };
}
