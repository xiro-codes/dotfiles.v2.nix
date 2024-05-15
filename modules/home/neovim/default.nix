{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  inherit (pkgs) writeShellApplication writeShellScriptBin;
  inherit (builtins) readFile toString;
  cfg = config.local;
in {
  imports = [];
  options.local.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (cfg.neovim.enable) {
    home.packages = [
      pkgs.neovide
      pkgs.rust-analyzer
      pkgs.nil
      pkgs.alejandra
      pkgs.nixpkgs-fmt
      pkgs.fzf
      pkgs.universal-ctags
      pkgs.python311Packages.autopep8
      pkgs.nodejs
    ];
    local.editor = "nvim";

    programs.neovim = {
      enable = true;

      extraLuaConfig = readFile ./init.lua;

      plugins = with pkgs.vimPlugins; [
        vim-nix
        dart-vim-plugin
        vim-toml

        lightline-vim
        lightline-gruvbox-vim
        gruvbox-nvim

        ranger-vim
        vista-vim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        luasnip
        cmp_luasnip
        nvim-surround
        rust-tools-nvim
        flutter-tools-nvim
        plenary-nvim
        copilot-vim
        rustaceanvim
      ];
      coc = {
        enable = false;
      };
    };
  };
}
