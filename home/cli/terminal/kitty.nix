{ desktop, ... }:
{
  programs.kitty = {
    enable = true;

    themeFile = "gruvbox-dark-hard";

    font = {
      name = "JetBrains Mono";
      size = 12;
    };

    extraConfig = ''
      font_features JetBrainsMono-Regular +ss01 +ss02 +ss04
      font_features JetBrainsMono-Bold +ss01 +ss02 +ss04
      font_features JetBrainsMono-Italic +ss01 +ss02 +ss04
      font_features JetBrainsMono-Light +ss01 +ss02 +ss04
    '';

    settings = {
      confirm_os_window_close = 0;
      background_opacity = (if desktop == "hyprland" then "0.66" else "1.0");
      scrollback_lines = 10000;
      enable_audio_bell = false;
      mouse_hide_wait = 60;
      window_padding_width = 5;
      copy_on_select = "yes";
      clear_all_shortcuts = "yes";

      ## Tabs
      tab_title_template = "{index}";
      active_tab_font_style = "normal";
      inactive_tab_font_style = "normal";
      tab_bar_style = "powerline";
      tab_powerline_style = "angled";
      active_tab_foreground = "#FBF1C7";
      active_tab_background = "#7C6F64";
      inactive_tab_foreground = "#FBF1C7";
      inactive_tab_background = "#3C3836";
    };

    keybindings = {
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    };
  };

  home.sessionVariables = {
    TERMINAL = "kitty";
  };

  #xdg.terminal-exec = {
  #  enable = true;
  #  settings = {
  #    default = [
  #      "kitty.desktop"
  #    ];
  #  };
  #};
}
