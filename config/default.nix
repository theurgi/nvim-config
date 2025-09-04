{pkgs, ...}: {
  vim = {
    extraPlugins = with pkgs.vimPlugins; {
      opencode = {
        package = opencode-nvim;

        setup = ''
          vim.g.opencode_opts = { auto_reload = true }
          vim.opt.autoread = true
        '';
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>ot";
        action = "<cmd>lua require('opencode').toggle()<CR>";
        desc = "Toggle opencode";
      }
      {
        mode = "n";
        key = "<leader>oA";
        action = "<cmd>lua require('opencode').ask()<CR>";
        desc = "Ask opencode";
      }
      {
        mode = "n";
        key = "<leader>oa";
        action = "<cmd>lua require('opencode').ask('@cursor: ')<CR>";
        desc = "Ask opencode about cursor";
      }
      {
        mode = "v";
        key = "<leader>oa";
        action = "<cmd>lua require('opencode').ask('@selection: ')<CR>";
        desc = "Ask opencode about selection";
      }
      {
        mode = ["n" "v"];
        key = "<leader>os";
        action = "<cmd>lua require('opencode').select()<CR>";
        desc = "Select opencode prompt";
      }
      {
        mode = "n";
        key = "<leader>oe";
        action = "<cmd>lua require('opencode').prompt('Explain @cursor and its context')<CR>";
        desc = "Explain code at cursor";
      }
      {
        mode = "n";
        key = "<leader>on";
        action = "<cmd>lua require('opencode').command('session_new')<CR>";
        desc = "New opencode session";
      }
      {
        mode = "n";
        key = "<leader>oy";
        action = "<cmd>lua require('opencode').command('messages_copy')<CR>";
        desc = "Copy last opencode response";
      }
    ];

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

    utility = {
      oil-nvim = {
        enable = true;

        setupOpts = {
          default_file_explorer = true;
          columns = ["icon"];
        };
      };

      snacks-nvim = {
        enable = true;
        setupOpts.input.enable = true;
      };
    };
  };
}
