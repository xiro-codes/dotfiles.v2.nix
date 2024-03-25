{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
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
        lspkind.enable = true;
        luasnip.enable = true;
        neo-tree.enable = true;
        nvim-lightbulb.enable = true;
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
            "<C-P>" = "cmp.mapping.complete()";
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-e>" = "cmp.mapping.close()";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Tab>" = "cmp.mapping.confirm({ select = true })";
            "<C-n>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<C-S-n>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          };
          sources = [
            {name = "nvim_lsp";}
            {name = "copilot";}
          ];
          snippet = {
            expand = "function(args) require('luasnip').lsp_expand(args.body) end";
          };
        };
        lsp = {
          enable = true;
          keymaps.lspBuf = {
            K = "hover";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
            "<leader>df" = "format";
          };
          servers = {
            nil_ls.enable = true;
            gleam.enable = true;
            nixd.enable = true;
            ccls.enable = true;
          };
        };
      };
    };
  };
}
