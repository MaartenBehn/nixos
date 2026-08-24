{
  nixvimConfig = {
    plugins.illuminate = {
      enable = true;
      settings = {
        underCursor = false;
        filetypesDenylist = [
          "Outline"
          "TelescopePrompt"
          "alpha"
          "harpoon"
          "reason"
        ];
      };
    };

    colorschemes.catppuccin.settings.integrations.illuminate = {
      enabled = true;
      lsp = true;
    };
  };
}
