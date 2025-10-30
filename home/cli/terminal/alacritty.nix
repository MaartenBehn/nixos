{ pkgs, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = {
      env.TERM = "xterm-256color";
      env.WINIT_X11_SCALE_FACTOR = "1";
      scrolling.history = 1000;
      font = {
        #size = 7;
        normal = {
          family = "JetBrains Mono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "JetBrains Mono Nerd Font";
          style = "Bold";
        };
        italic = {
          family = "JetBrains Mono Nerd Font";
          style = "Italic";
        };
      };
    };
  };

  home.sessionVariables = {
    TERMINAL = "alacritty";
  };

  
  #xdg.terminal-exec = {
  #  enable = true;
  #  settings = {
  #    default = [
  #      "alacritty.desktop"
  #    ];
  #  };
  #};
}
