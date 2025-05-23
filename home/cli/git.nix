{ pkgs, ... }: {
  programs.git = {
    enable = true;

    userName = "Maarten Behn";
    userEmail = "maarten.behn@gmail.com"; 

    extraConfig = {
      init.defaultBranch = "main";
      credential.helper = "store";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.rebase = false;
    };

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        side-by-side = true;
        diff-so-fancy = true;
        navigate = true;
      };
    };
  };

  home.packages = [ pkgs.gh ]; # pkgs.git-lfs
}
