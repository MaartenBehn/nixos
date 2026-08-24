{
  nixvimConfig = {
    plugins.telescope = {
      enable = true;
      extensions = {
        file-browser = {
          enable = true;
        };
        fzf-native = {
          enable = true;
        };
      };
      settings = {
        defaults = {
          layout_config = {
            horizontal = {
              prompt_position = "top";
            };
          };
          sorting_strategy = "ascending";
        };
      };
      keymaps = {
        "<leader><space>" = {
          action = "live_grep";
          options = {
            desc = "Grep";
          };
        };
        "<leader>cc" = {
          action = "lsp_document_symbols";
          options = {
            desc = "Find in file";
          };
        };
        "<leader>cs" = {
          action = "lsp_dynamic_workspace_symbols";
          options = {
            desc = "Find in Workspace";
          };
        };
        "<leader>fr" = {
          action = "resume";
          options = {
            desc = "Show last search";
          };
        };
        "<leader>ff" = {
          action = "find_files";
          options = {
            desc = "Find project files";
          };
        };
        "<leader>ft" = {
          action = "current_buffer_fuzzy_find";
          options = {
            desc = "Find text";
          };
        }; 
        "<leader>fb" = {
          action = "buffers";
          options = {
            desc = "Buffers";
          };
        };
        "<leader>fa" = {
          action = "autocommands";
          options = {
            desc = "Auto Commands";
          };
        };
        "<leader>fc" = {
          action = "command_history";
          options = {
            desc = "Command History";
          };
        };
        "<leader>f:" = {
          action = "commands";
          options = {
            desc = "Commands";
          };
        };
        "<leader>fd" = {
          action = "diagnostics";
          options = {
            desc = "Workspace diagnostics";
          };
        };
        "<leader>fh" = {
          action = "help_tags";
          options = {
            desc = "Help pages";
          };
        };
        "<leader>fH" = {
          action = "highlights";
          options = {
            desc = "Search Highlight Groups";
          };
        };
        "<leader>fk" = {
          action = "keymaps";
          options = {
            desc = "Keymaps";
          };
        };
        "<leader>fM" = {
          action = "man_pages";
          options = {
            desc = "Man pages";
          };
        };
        "<leader>fm" = {
          action = "marks";
          options = {
            desc = "Jump to Mark";
          };
        };
        "<leader>fo" = {
          action = "vim_options";
          options = {
            desc = "Options";
          };
        };
      };
    };

    extraConfigLua = ''
    require("telescope").setup{
      pickers = {
        colorscheme = {
          enable_preview = true
        }
      }
    }
    '';

    colorschemes.catppuccin.settings.integrations.telescope.enabled = true;
  };
}
