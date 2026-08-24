{
  nixvimConfig = {
    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          background = {
            light = "macchiato";
            dark = "mocha";
          };
          custom_highlights = ''
          function(highlights)
            return {
            CursorLineNr = { fg = highlights.peach, style = {} },
            NavicText = { fg = highlights.text },
            }
          end
          '';
          flavour = "macchiato"; # "latte", "mocha", "frappe", "macchiato" or raw lua code
          no_bold = false;
          no_italic = false;
          no_underline = false;
          transparent_background = true;
          integrations = {
            cmp = true;
            gitsigns = true;
          };
        };
      };
    };

    extraConfigLua = ''
      -- Fix backound color bug: 
      -- https://github.com/nvim-telescope/telescope.nvim/issues/2145
      vim.api.nvim_set_hl(0, 'NormalFloat', { bg = "none" })
      vim.api.nvim_set_hl(0, 'FloatBorder', { bg = "none" })
      vim.api.nvim_set_hl(0, 'FloatTitle', { bg = "none" })
    '';
  };
}
