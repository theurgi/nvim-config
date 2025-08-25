{pkgs, ...}: {
  vim = {
    mini = {
      ai.enable = true;
      comment.enable = true;
      icons.enable = true;
      pairs.enable = true;
      surround.enable = true;
    };

    options = {
      autoindent = true;
      cursorlineopt = "both";
      expandtab = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      signcolumn = "yes";
      smartindent = true;
      splitbelow = true;
      splitright = true;
      tabstop = 2;
      termguicolors = true;
      timeoutlen = 500;
      updatetime = 250;
      wrap = false;
    };

    statusline.lualine = {
      enable = true;
      disabledFiletypes = ["alpha"];
      globalStatus = true;
      icons.enable = true;
      theme = "auto";
    };

    treesitter = {
      enable = true;
      fold = true;
      highlight.enable = true;
      incrementalSelection.enable = true;
      indent.enable = true;

      context = {
        enable = true;
        setupOpts = {
          separator = "-";
          max_lines = 3;
        };
      };

      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        lua
        nix
        bash
        json
        yaml
        typescript
      ];

      textobjects = {
        enable = true;
        setupOpts = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
            };
          };
        };
      };
    };
  };
}
