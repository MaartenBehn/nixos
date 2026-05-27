{
  flake.modules.homeManager.hyprland = {pkgs, ... }: {
    home.packages = with pkgs; [
      kitty
      (writeShellScriptBin "open_vim_cheat_sheet" ''
        hyprctl dispatch -- exec 'kitty --class kitty_vim nvim ~/Notes/Cards/vim\ bindings.md' 
      '') 
    ];
  };
}
