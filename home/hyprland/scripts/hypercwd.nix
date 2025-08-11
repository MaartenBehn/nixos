{ pkgs, ... }: 
let
  hyprcwd = pkgs.writeShellScriptBin "hyprcwd" ''
  pid=$(hyprctl activewindow -j | jq '.pid')
  ppid=$(pgrep --newest --parent "$pid")
  dir=$(readlink /proc/"$ppid"/cwd || echo "$HOME")
  [ -d "$dir" ] && echo "$dir" || echo "$HOME"
  '';
in {
  home.packages = (with pkgs; [
    jq
    hyprcwd
  ]);
}
