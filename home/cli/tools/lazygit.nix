{ inputs, pkgs, ... }:
{
  home.packages = (with pkgs; [ lazygit ]);

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
 
  home.shellAliases = {
      lgit="lazygit";
      lg="lazygit";
  };
}
