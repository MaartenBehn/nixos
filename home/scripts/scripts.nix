{ pkgs, ... }:
let
  trigger_alacritty_hyprland = pkgs.writeShellScriptBin "trigger_alacritty_hyprland" (
    builtins.readFile ./trigger_alacritty_hyprland.sh
  );

  trigger_ghostty_hyprland = pkgs.writeShellScriptBin "trigger_ghostty_hyprland" (
    builtins.readFile ./trigger_ghostty_hyprland.sh
  );
  
  trigger_kitty_hyprland = pkgs.writeShellScriptBin "trigger_kitty_hyprland" (
    builtins.readFile ./trigger_kitty_hyprland.sh
  );
  
  trigger_alacritty_kde = pkgs.writeShellScriptBin "trigger_alacritty_kde" (
    builtins.readFile ./trigger_alacritty_kde.sh
  );
  
  trigger_kitty_kde = pkgs.writeShellScriptBin "trigger_kitty_kde" (
    builtins.readFile ./trigger_kitty_kde.sh
  );

  vpn_to_behns = pkgs.writeShellScriptBin "vpn_to_behns" (
    builtins.readFile ./vpn_to_behns.sh
  );

  # From https://github.com/Frost-Phoenix/nixos-config/blob/main/modules/home/scripts/scripts.nix
  wall-change = pkgs.writeShellScriptBin "wall-change" (
    builtins.readFile ./wall-change.sh
  );
  wallpaper-picker = pkgs.writeShellScriptBin "wallpaper-picker" (
    builtins.readFile ./wallpaper-picker.sh
  );
  random-wallpaper = pkgs.writeShellScriptBin "random-wallpaper" (
    builtins.readFile ./random-wallpaper.sh
  );

  runbg = pkgs.writeShellScriptBin "runbg" (builtins.readFile ./runbg.sh);
  music = pkgs.writeShellScriptBin "music" (builtins.readFile ./music.sh);
  lofi = pkgs.writeScriptBin "lofi" (builtins.readFile ./lofi.sh);

  toggle_blur = pkgs.writeScriptBin "toggle_blur" (
    builtins.readFile ./toggle_blur.sh
  );
  toggle_oppacity = pkgs.writeScriptBin "toggle_oppacity" (
    builtins.readFile ./toggle_oppacity.sh
  );
  toggle_waybar = pkgs.writeScriptBin "toggle_waybar" (
    builtins.readFile ./toggle_waybar.sh
  );
  toggle_float = pkgs.writeScriptBin "toggle_float" (
    builtins.readFile ./toggle_float.sh
  );

  maxfetch = pkgs.writeScriptBin "maxfetch" (
    builtins.readFile ./maxfetch.sh
  );

  compress = pkgs.writeScriptBin "compress" (
    builtins.readFile ./compress.sh
  );
  extract = pkgs.writeScriptBin "extract" (
    builtins.readFile ./extract.sh
  );

  show-keybinds = pkgs.writeScriptBin "show-keybinds" (
    builtins.readFile ./keybinds.sh
  );

  vm-start = pkgs.writeScriptBin "vm-start" (
    builtins.readFile ./vm-start.sh
  );

  ascii = pkgs.writeScriptBin "ascii" (builtins.readFile ./ascii.sh);

  record = pkgs.writeScriptBin "record" (builtins.readFile ./record.sh);

  screenshot = pkgs.writeScriptBin "screenshot" (
    builtins.readFile ./screenshot.sh
  );

  rofi-power-menu = pkgs.writeScriptBin "rofi-power-menu" (
    builtins.readFile ./rofi-power-menu.sh
  );
  power-menu = pkgs.writeScriptBin "power-menu" (
    builtins.readFile ./power-menu.sh
  );
  set-monitors = pkgs.writeScriptBin "set-monitors" (
    builtins.readFile ./set-monitors.sh
  );

  update_duckdns = pkgs.writeScriptBin "update_duckdns" (
    builtins.readFile ./update_duckdns.sh
  );

  update_nix_index = pkgs.writeScriptBin "update_nix_index" (
    builtins.readFile ./update_nix_index.sh
  );
in
{
  home.packages = [
    update_nix_index
    update_duckdns

    set-monitors

    trigger_ghostty_hyprland
    trigger_alacritty_hyprland
    trigger_kitty_hyprland
    trigger_alacritty_kde
    trigger_kitty_kde

    vpn_to_behns
    
    wall-change
    wallpaper-picker
    random-wallpaper

    runbg
    music
    lofi

    toggle_blur
    toggle_oppacity
    toggle_waybar
    toggle_float

    maxfetch

    compress
    extract

    show-keybinds

    vm-start

    ascii

    record

    screenshot

    rofi-power-menu
    power-menu
    
    pkgs.zenity                            # Gui Dialogs (used in scripts) 
  ];
}
