{ pkgs, ... }: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Maarten Behn";
        email = "maarten.behn@gmail.com";
      };

      init.defaultBranch = "main";
      credential.helper = "store";
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      pull.rebase = false;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      line-numbers = true;
      side-by-side = true;
      diff-so-fancy = true;
      navigate = true;
    };
  };
  
  home.packages = [ pkgs.gh ]; # pkgs.git-lfs
}
