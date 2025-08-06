{pkgs, ... }: 
let
  script = pkgs.writeShellScriptBin "open_vim_cheat_sheet" ''
    #!/usr/bin/env bash

    hyprctl dispatch -- exec 'kitty --class kitty_vim nvim ~/Notes/Cards/vim\ bindings.md' 
  ''; 
in {
  home.packages = (with pkgs; [
    kitty
    script 
  ]);
}
