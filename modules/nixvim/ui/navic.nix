{
  nixvimConfig = {
    plugins.navic = {
      enable = true;
      settings = {
        separator = "  ";
        highlight = true;
        depthLimit = 5;
        lsp = {
          autoAttach = true;
        };
        icons = {
          Array = "󱃵  ";
          Boolean = "  ";
          Class = "  ";
          Constant = "  ";
          Constructor = "  ";
          Enum = " ";
          EnumMember = " ";
          Event = " ";
          Field = "󰽏 ";
          File = " ";
          Function = "󰡱 ";
          Interface = " ";
          Key = "  ";
          Method = " ";
          Module = "󰕳 ";
          Namespace = " ";
          Null = "󰟢 ";
          Number = " ";
          Object = "  ";
          Operator = " ";
          Package = "󰏖 ";
          String = " ";
          Struct = " ";
          TypeParameter = " ";
          Variable = " ";
        };
      };
    };

    colorschemes.catppuccin.settings.integrations.navic = {
      enabled = true;
      custom_bg = "NONE"; # "lualine" will set background to mantle
    };
  };
}
