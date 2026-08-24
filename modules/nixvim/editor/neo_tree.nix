# https://github.com/nvim-neo-tree/neo-tree.nvim?tab=readme-ov-file

{
  nixvimConfig = {
    plugins.neo-tree = {
      enable = true;
      settings = {
        sources = [
          "filesystem"
          "buffers"
          "document_symbols"
        ];
        close_if_last_window = true;

        filesystem = {
          bind_to_cwd = false;
          follow_current_file = {
            enabled = true;
          };
          filtered_items = {
            visible = true;
          };
        };

        default_component_configs = {
          indent = {
            with_expanders = true;
            expander_collapsed = "󰅂";
            expander_expanded = "󰅀";
            expander_highlight = "NeoTreeExpander";
          };

          git_status = {
            symbols = {
              added = " ";
              conflict = "󰩌 ";
              deleted = "󱂥 ";
              ignored = " ";
              modified = " ";
              renamed = "󰑕 ";
              staged = "";
              unstaged = "";
              untracked = "";
            };
          };
        };
      };
    };

    keymaps = [
      {
        mode = [ "n" ];
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options = {
          desc = "Neotree";
        };
      }
    ];

    colorschemes.catppuccin.settings.integrations.neotree = true;
  };
}
