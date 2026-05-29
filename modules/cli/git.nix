{
  flake.modules.homeManager.cli = { pkgs, ... }: {
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

    # https://github.com/jesseduffield/lazygit/blob/master/docs/Config.md
    xdg.configFile."lazygit/config.yml".text = ''
      gui:
        border: single
      git:
        pagers: 
          - delta:
            colorArg: "always"
            pager: "delta --paging=never"
    '';

    home.packages = with pkgs; [ 
      lazygit
      gh 
    ];

    home.shellAliases = {
      lgit="lazygit";
      lg="lazygit";
    };
  };
}
