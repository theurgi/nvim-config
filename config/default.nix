{pkgs, ...}: {
  vim = {
    autocomplete.nvim-cmp = {
      enable = true;

      sourcePlugins = [
        "cmp-nvim-lsp"
        "cmp-path"
        "cmp-buffer"
        "cmp-treesitter"
        "luasnip"
      ];

      sources = {
        nvim-cmp = null;
        path = "[Path]";
        buffer = "[Buffer]";
        nvim_lsp = "[LSP]";
        treesitter = "[Treesitter]";
        luasnip = "[LuaSnip]";
      };

      setupOpts.completion.completeopt = "menu,menuone,noinsert,noselect";

      mappings = {
        confirm = "<CR>";
        complete = "<C-Space>";
        close = "<C-e>";
        next = "<Tab>";
        previous = "<S-Tab>";
        scrollDocsUp = "<C-d>";
        scrollDocsDown = "<C-f>";
      };
    };

    binds.whichKey = {
      enable = true;

      setupOpts = {
        preset = "modern";
        win.border = "rounded";
      };

      register = {
        o = "+opencode";
      };
    };

    extraPlugins = with pkgs.vimPlugins; {
      friendly-snippets = {
        package = friendly-snippets;
        setup = "require('luasnip.loaders.from_vscode').lazy_load()";
      };

      opencode = {
        package = opencode-nvim;

        setup = ''
          vim.g.opencode_opts = { auto_reload = true }
          vim.opt.autoread = true
        '';
      };
    };

    git = {
      gitsigns.enable = true;
      vim-fugitive.enable = true;
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
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<cr>";
        desc = "Toggle floating terminal";
      }
      {
        mode = "t";
        key = "<esc>";
        action = "<C-\\><C-n>";
        desc = "Exit terminal mode";
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

    snippets.luasnip.enable = true;

    statusline.lualine = {
      enable = true;
      disabledFiletypes = ["alpha"];
      globalStatus = true;
      icons.enable = true;
      theme = "auto";
    };

    telescope = {
      enable = true;

      setupOpts.defaults = {
        initial_mode = "insert";
        path_display = ["smart"];
        layout_strategy = "horizontal";

        layout_config = {
          preview_cutoff = 120;
          horizontal.preview_width = 0.55;
        };

        file_ignore_patterns = [
          "node_modules"
          "%.git/"
          "dist/"
          "build/"
          "target/"
          "result/"
        ];
      };

      extensions = [
        {
          name = "fzf";
          packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
          setup = {
            fzf = {
              fuzzy = true;
              override_generic_sorter = true;
              override_file_sorter = true;
            };
          };
        }
      ];
    };

    terminal.toggleterm = {
      enable = true;
      setupOpts.direction = "float";
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
