{ pkgs, ... }:
{
  vim = {
    # Re-add ~/.config/nvim to the runtimepath: nvf's mnw wrapper isolates rtp, so the
    # Noctalia-rendered lua/matugen.lua is otherwise unreachable. Needed both for the
    # startup require below AND matugen.lua's own SIGUSR1 self-reload (it require()s
    # 'matugen'). Impure absolute path — see luaConfigPost / theme.name notes below.
    additionalRuntimePaths = [ "$HOME/.config/nvim" ];

    autocomplete = {
      nvim-cmp = {
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
    };

    binds = {
      whichKey = {
        enable = true;

        setupOpts = {
          preset = "modern";
          win.border = "rounded";
        };
      };
    };

    dashboard = {
      alpha.enable = true;
    };

    diagnostics = {
      nvim-lint = {
        enable = true;
        lint_after_save = true;

        lint_function = pkgs.lib.mkLuaInline ''
          function(buf)
            require("lint").try_lint()
          end
        '';

        linters_by_ft = {
          typescript = [ "eslint" ];
          javascript = [ "eslint" ];
        };
      };
    };

    extraPlugins = with pkgs.vimPlugins; {
      # Provides the `base16-colorscheme` module that Noctalia's matugen.lua calls; the
      # palette is applied by the luaConfigPost bootstrap, not here.
      base16-nvim.package = base16-nvim;

      friendly-snippets = {
        package = friendly-snippets;
        setup = "require('luasnip.loaders.from_vscode').lazy_load()";
      };
    };

    formatter = {
      conform-nvim = {
        enable = true;

        setupOpts = {
          formatters_by_ft = {
            javascript = [ "prettier" ];
            typescript = [ "prettier" ];
            javascriptreact = [ "prettier" ];
            typescriptreact = [ "prettier" ];
            markdown = [ "prettier" ];
            nix = [ "nixfmt" ];
            sh = [ "shfmt" ];
            bash = [ "shfmt" ];
            zsh = [ "shfmt" ];
          };

          format_on_save = pkgs.lib.mkLuaInline ''
            function(buf)
              require("conform").format()
            end
          '';
        };
      };
    };

    git = {
      gitsigns.enable = true;
      vim-fugitive.enable = true;
    };

    keymaps = [
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
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Oil<cr>";
        desc = "Open Oil file manager";
      }
    ];

    lsp = {
      formatOnSave = true;

      servers = {
        bash-language-server = {
          enable = true;
          filetypes = [
            "sh"
            "bash"
          ];
          cmd = [
            "bash-language-server"
            "start"
          ];
        };

        lua-language-server = {
          enable = true;
          filetypes = [ "lua" ];
          cmd = [ "lua-language-server" ];
        };

        marksman = {
          enable = true;
          filetypes = [ "markdown" ];
          cmd = [
            "marksman"
            "server"
          ];
        };

        nil = {
          enable = true;
          filetypes = [ "nix" ];
          cmd = [ "nil" ];
        };

        typescript-language-server = {
          enable = true;
          filetypes = [
            "typescript"
            "javascript"
            "typescriptreact"
            "javascriptreact"
          ];
          cmd = [
            "typescript-language-server"
            "--stdio"
          ];
        };
      };
    };

    # Apply the Noctalia palette over the static fallback theme, if present. Guarded so
    # `nix run github:theurgi/nvim-config` on any machine (no matugen.lua) just keeps nord.
    # Runs after plugins load → base16-colorscheme is available. matugen.lua self-registers
    # a SIGUSR1 handler on require, so Noctalia's post_hook (`pkill -SIGUSR1 nvim`) live-
    # reloads the palette. Requires ~/.config/nvim on rtp (see additionalRuntimePaths).
    luaConfigPost = ''
      -- Transparency: clear the editor-area backgrounds so the terminal shows through —
      -- under ghostty (background-opacity 0.9) + Hyprland blur, nvim then inherits both.
      -- `highlight … guibg=NONE` only touches bg (keeps fg/attrs). Must re-run after every
      -- colorscheme apply, since each repaints Normal et al. with a solid bg. Floats/popups
      -- (Pmenu, NormalFloat, Telescope) deliberately stay opaque → readable over the blur.
      local function clearBg()
        for _, g in ipairs({
          "Normal", "NormalNC", "SignColumn", "EndOfBuffer",
          "LineNr", "CursorLineNr", "FoldColumn", "MsgArea", "NonText",
        }) do
          pcall(vim.cmd, "highlight " .. g .. " guibg=NONE ctermbg=NONE")
        end
      end
      clearBg() -- the static fallback (nord) path, when no palette is rendered

      local ok, m = pcall(require, "matugen")
      if ok and m and m.setup then
        -- Re-assert our look after matugen paints the palette: clear backgrounds again,
        -- and drive lualine from its own "base16" theme (it won't follow base16 on its
        -- own — theme "auto" latches the startup colorscheme and base16-colorscheme.setup()
        -- fires no ColorScheme event).
        local function apply()
          clearBg()
          pcall(function() require("lualine").setup({options = {theme = "base16"}}) end)
        end
        m.setup()
        apply()

        -- Live-reload: Noctalia sends SIGUSR1 and matugen's own handler (registered on the
        -- require above) repaints. libuv signal-handler order is UNSPECIFIED, so we defer
        -- our apply one extra tick (schedule-inside-schedule) to land AFTER matugen's
        -- repaint — otherwise its solid Normal clobbers our transparency. Ref kept so the
        -- active signal handle isn't garbage-collected.
        _G.__noctalia_nvim_signal = vim.uv.new_signal()
        _G.__noctalia_nvim_signal:start("sigusr1", vim.schedule_wrap(function()
          vim.schedule(apply)
        end))
      end
    '';

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

    snippets = {
      luasnip.enable = true;
    };

    statusline = {
      lualine = {
        enable = true;
        disabledFiletypes = [ "alpha" ];
        globalStatus = true;
        icons.enable = true;
        theme = "auto";
      };
    };

    telescope = {
      enable = true;

      setupOpts.defaults = {
        initial_mode = "insert";
        path_display = [ "smart" ];
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
          packages = [ pkgs.vimPlugins.telescope-fzf-native-nvim ];
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

    terminal = {
      toggleterm = {
        enable = true;
        setupOpts.direction = "float";
      };
    };

    # Fallback colorscheme: shown standalone (`nix run`) or before Noctalia has rendered a
    # palette. The luaConfigPost matugen bootstrap overrides it whenever matugen.lua exists.
    theme = {
      enable = true;
      name = "nord";
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

    undoFile = {
      enable = true;
      path = pkgs.lib.mkLuaInline ''
        vim.fn.stdpath("data") .. "/undo"
      '';
    };

    utility = {
      oil-nvim = {
        enable = true;

        setupOpts = {
          default_file_explorer = true;
          columns = [ "icon" ];
        };
      };

      snacks-nvim = {
        enable = true;
        setupOpts.input.enable = true;
      };
    };
  };
}
