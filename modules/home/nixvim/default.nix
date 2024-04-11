{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkOption mkIf types getExe;
  cfg = config.local;
in {
  imports = [];
  options.local.nixvim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (cfg.nixvim.enable) {
    local.editor = "nvim";
    programs.nixvim = {
      package = inputs.neovim-nightly.packages.${pkgs.system}.neovim;
      enable = true;
      extraPlugins = [
        {plugin = pkgs.vimPlugins.zoxide-vim;}
        {plugin = pkgs.vimPlugins.fzf-vim;}
        #{plugin = pkgs.vimPlugins.qmk-nvim;}
      ];
      globals.mapleader = ";";
      options = {
        number = true;
        relativenumber = true;
        splitbelow = true;
        splitright = true;
        tabstop = 2;
        softtabstop = 2;
        shiftwidth = 2;
        smartindent = true;
        autoindent = true;
        spellsuggest = "best,9";
        spelloptions = "camel";
        undofile = true;
        wrap = false;
      };
      colorschemes.gruvbox = {
        enable = true;
        settings = {
          palette_overrides = {
            light0 = "#FFFFFF";
          };
        };
      };
      keymaps = [
        {
          action = "o<Esc>";
          key = "o";
          mode = ["n"];
          options = {};
        }
        {
          action = "O<Esc>";
          key = "O";
          mode = ["n"];
          options = {};
        }
        {
          key = "<C-H>";
          mode = ["n"];
          action = "<C-W><C-H>";
          options = {};
        }
        {
          key = "<C-J>";
          mode = ["n"];
          action = "<C-W><C-J>";
          options = {};
        }
        {
          key = "<C-K>";
          mode = ["n"];
          action = "<C-W><C-K>";
          options = {};
        }
        {
          key = "<C-L>";
          mode = ["n"];
          action = "<C-W><C-L>";
          options = {};
        }
        {
          key = "<C-S-H>";
          mode = ["n"];
          action = "<C-W><C-S-H>";
          options = {};
        }
        {
          key = "<C-S-J>";
          mode = ["n"];
          action = "<C-W><C-S-J>";
          options = {};
        }
        {
          key = "<C-S-K>";
          mode = ["n"];
          action = "<C-W><C-S-K>";
          options = {};
        }
        {
          key = "<C-S-L>";
          mode = ["n"];
          action = "<C-W><C-S-L>";
          options = {};
        }
        {
          key = "<leader>f";
          mode = ["n"];
          action = ":Neotree<CR>";
          options = {};
        }
      ];
      autoCmd = [
        {
          event = ["BufWritePre" "FileWritePre"];
          pattern = "*";
          command = "%s/\s\+$//e";
        }
        {
          event = ["BufNewFile" "BufRead"];
          pattern = "*.tera";
          command = ":set filetype=html";
        }
      ];
      clipboard.register = "unnamedplus";
      extraConfigLua = ''
        HOME = os.getenv("HOME")
        vim.opt.undodir = HOME .. "/.config/nvim/undo"
        vim.o.background = "light"
        --require("lazy").setup({
        --	{
        --		"codethread/qmk.nvim", main = "qmk", opts = {
        --			name = "LAYOUT_ortho_4x12",
        --			layout = {
        --				'x x x x x x x x x x x x',
        --				'x x x x x x x x x x x x',
        --				'x x x x x x x x x x x x',
        --				'x x x x x x x x x x x x',
        --			},
        --		},
        --	}
        --})
        if vim.g.neovide then
        	vim.o.guifont = "Cascadia Code:h10"
        	vim.g.neovide_cursor_vfx_mode = "railgun"
        	vim.g.neovide_fullscreen = false;
        end
      '';
      extraConfigVim = ''
        set iskeyword-=_
      '';
      plugins = {
        lualine.enable = false;
        lsp-format.enable = true;
        bufferline.enable = true;
        lsp-lines = {
          enable = true;
          currentLine = true;
        };
        lazy.enable = true;
        lspkind.enable = true;
        luasnip.enable = true;
        neo-tree.enable = true;
        rustaceanvim = {
          enable = true;
          server.settings = {
            files = {
              excludeDirs = [".direnv"];
            };
          };
        };

        treesitter.enable = true;
        copilot-cmp.enable = true;
        nvim-colorizer.enable = true;
        cmp-nvim-lsp.enable = true;
        cmp.enable = true;
        cmp.settings = {
          mapping = {
            "<C-q>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-p>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            {name = "copilot";}
            {name = "nvim_lsp";}
          ];
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
        };
        lsp = {
          enable = true;
          keymaps.lspBuf = {
            sh = "hover";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
            rn = "rename";
            "<leader>df" = "format";
            #"<leader>ca" = "codeactions";
          };
          servers = {
            nil_ls.enable = true;
            gleam.enable = true;
            tsserver.enable = true;
            html.enable = true;
            nixd = {
              enable = true;
              settings = {
                eval = {
                  depth = 10;
                  workers = 8;
                };
                options = {
                  enable = true;
                  target = {installable = ".#nixosConfigurations.Sapphire.options";};
                };
                formatting.command = "${getExe pkgs.alejandra}";
              };
            };
          };
        };
      };
    };
  };
}
