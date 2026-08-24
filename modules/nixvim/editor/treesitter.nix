{
  nixvimConfig = { pkgs, ... }: {
    plugins.treesitter = {
      enable = true;
      settings = {
        indent.enable = true;
        highlight.enable = true;
      };
      folding = true;
      nixvimInjections = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        bash
        c
        c_sharp
        cmake
        cpp
        css
        cuda
        dockerfile
        dot
        doxygen
        fish
        gitignore
        glsl
        go
        haskell
        haskell_persistent
        hlsl
        html
        java
        javadoc
        javascript
        json
        just
        latex
        lua
        make
        markdown
        markdown_inline
        nix
        r
        rust
        sql
        toml
        typescript
        typst
        yaml
        zig
      ];  
    };

    plugins.treesitter-textobjects = {
      enable = false;
      settings = {
        select = {
          enable = true;
          lookahead = true;
          keymaps = {
            "aa" = "@parameter.outer";
            "ia" = "@parameter.inner";
            "af" = "@function.outer";
            "if" = "@function.inner";
            "ac" = "@class.outer";
            "ic" = "@class.inner";
            "ii" = "@conditional.inner";
            "ai" = "@conditional.outer";
            "il" = "@loop.inner";
            "al" = "@loop.outer";
            "at" = "@comment.outer";
          };
        };
        move = {
          enable = true;
          gotoNextStart = {
            "]m" = "@function.outer";
            "öm" = "@function.outer";
            "]]" = "@class.outer";
            "öö" = "@class.outer";
          };
          gotoNextEnd = {
            "]M" = "@function.outer";
            "öM" = "@function.outer";
            "][" = "@class.outer";
            "öä" = "@class.outer";
          };
          gotoPreviousStart = {
            "[m" = "@function.outer";
            "äm" = "@function.outer";
            "[[" = "@class.outer";
            "ää" = "@class.outer";
          };
          gotoPreviousEnd = {
            "[M" = "@function.outer";
            "äM" = "@function.outer";
            "[]" = "@class.outer";
            "äö" = "@class.outer";
          };
        };
        swap = {
          enable = true;
          swapNext = {
            "<leader>a" = "@parameters.inner";
          };
          swapPrevious = {
            "<leader>A" = "@parameter.outer";
          };
        };
      };
    };

    colorschemes.catppuccin.settings.integrations.treesitter = true;
  };
}
