{
  flake.modules.homeManager.hyprland = { pkgs, ... }: {
      home.packages = with pkgs; [
        jq
        (writeShellScriptBin "hyprcwd" ''
          pid=$(hyprctl activewindow -j | jq '.pid')
          ppid=$(pgrep --newest --parent "$pid")
          dir=$(readlink /proc/"$ppid"/cwd || echo "$HOME")
          [ -d "$dir" ] && echo "$dir" || echo "$HOME"
      '')
      ];
    };
}
