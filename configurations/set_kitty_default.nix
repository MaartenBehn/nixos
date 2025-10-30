{ ... }: {

  # TODO move to home manager as soon as it become avaliable
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };
}
