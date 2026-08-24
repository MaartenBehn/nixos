{
  nixvimConfig = {
    globals.mapleader = " ";

    keymaps = [
      # Paste and keep in visual
      {
        mode = [
          "v"
        ];
        key = "p";
        action = "<S-p>";
        options = {
          remap = true;
        };
      } 
      {
        mode = [
          "n"
          "x"
        ];
        key = "j";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      } 
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Down>";
        action = "v:count == 0 ? 'gj' : 'j'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "k";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = [
          "n"
          "x"
        ];
        key = "<Up>";
        action = "v:count == 0 ? 'gk' : 'k'";
        options = {
          expr = true;
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<A-j>";
        action = "<cmd>m .+1<cr>==";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "n";
        key = "<A-k>";
        action = "<cmd>m .-2<cr>==";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = "i";
        key = "<A-j>";
        action = "<esc><cmd>m .+1<cr>==gi";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "i";
        key = "<A-k>";
        action = "<esc><cmd>m .-2<cr>==gi";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = "v";
        key = "<A-j>";
        action = ":m '>+1<cr>gv=gv";
        options = {
          desc = "Move Down";
        };
      }
      {
        mode = "v";
        key = "<A-k>";
        action = ":m '<-2<cr>gv=gv";
        options = {
          desc = "Move Up";
        };
      }
      {
        mode = [
          "n"
          "v"
          "i"
        ];
        key = "<c-d>";
        action = "<c-d>zz";
        options = {
          desc = "One Page down";
        };
      }
      {
        mode = [
          "n"
          "v"
          "i"
        ];
        key = "<c-u>";
        action = "<c-u>zz";
        options = {
          desc = "One Page up";
        };
      }
      {
        mode = [
          "i"
          "x"
          "n"
          "s"
        ];
        key = "<C-s>";
        action = "<cmd>wa<cr><esc>";
        options = {
          desc = "Save All File";
        };
      }


      {
        mode = "n";
        key = "<C-Left>";
        action = "<C-w>h";
        options = {
          desc = "Go to Left Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<C-w>j";
        options = {
          desc = "Go to Lower Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-Up>";
        action = "<C-w>k";
        options = {
          desc = "Go to Upper Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<C-w>l";
        options = {
          desc = "Go to Right Window";
          remap = true;
        };
      }
      {
        mode = "n";
        key = "<C-A-Up>";
        action = "<cmd>resize +2<cr>";
        options = {
          desc = "Increase Window Height";
        };
      }
      {
        mode = "n";
        key = "<C-A-Down>";
        action = "<cmd>resize -2<cr>";
        options = {
          desc = "Decrease Window Height";
        };
      }
      {
        mode = "n";
        key = "<C-A-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options = {
          desc = "Decrease Window Width";
        };
      }
      {
        mode = "n";
        key = "<C-A-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options = {
          desc = "Increase Window Width";
        };
      }

      {
        mode = [
          "i"
          "n"
        ];
        key = "<esc>";
        action = "<cmd>noh<cr><esc>";
        options = {
          desc = "Escape and Clear hlsearch";
        };
      }
      {
        mode = "n";
        key = "n";
        action = "'Nn'[v:searchforward].'zv'";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = "x";
        key = "n";
        action = "'Nn'[v:searchforward]";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = "o";
        key = "n";
        action = "'Nn'[v:searchforward]";
        options = {
          expr = true;
          desc = "Next Search Result";
        };
      }
      {
        mode = "n";
        key = "N";
        action = "'nN'[v:searchforward].'zv'";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = "x";
        key = "N";
        action = "'nN'[v:searchforward]";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = "o";
        key = "N";
        action = "'nN'[v:searchforward]";
        options = {
          expr = true;
          desc = "Prev Search Result";
        };
      }
      {
        mode = "n";
        key = "q";
        action = "<cmd>q<cr>";
        options = {
          desc = "Quit this";
        };
      }
      {
        mode = "n";
        key = "<leader>q<cr>";
        action = "<cmd>q<cr>";
        options = {
          desc = "Quit this";
        };
      }
      {
        mode = "n";
        key = "<leader>qq";
        action = "<cmd>qa<cr>";
        options = {
          desc = "Quit All";
        };
      }
    ];

    extraConfigLuaPre = ''
      -- Remove all keymaps starting with 'q'
      local function remove_q_keymaps()
        local modes = { 'n', 'v', 'x', 'o', 'i', 'c', 't', 's' }
        for _, mode in ipairs(modes) do
          local keymaps = vim.api.nvim_get_keymap(mode)
          for _, keymap in ipairs(keymaps) do
            if keymap.lhs:match('^q') then
              pcall(vim.keymap.del, mode, keymap.lhs)
            end
          end
        end
      end

      remove_q_keymaps()
    '';
  };
}
