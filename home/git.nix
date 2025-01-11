{ ... }: {
  programs.git = {
    enable = true;
    userName = "Maarten Behn";
    userEmail = "maarten.behn@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      merge.tool = "meld";
    };
  };
}
