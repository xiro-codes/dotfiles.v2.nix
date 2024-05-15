{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf types;
  cfg = config.local;
in {
  imports = [
  ];
  options.local = {
    enable = mkEnableOption "Enable custom tweaks most UX and Sytle focused.";

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [];
    };

    editor = mkOption {
      type = types.str;
      default = "nvim";
    };

    guiEditor = mkOption {
      type = types.str;
      default = "";
    };

    fileManager = mkOption {
      type = types.str;
      default = "";
    }; # enable a console filemanager
    guiFileManager = mkOption {
      type = types.str;
      default = "";
    };

    terminal = mkOption {
      type = types.str;
      default = "";
    };
    guiTerminal = mkOption {
      type = types.str;
      default = "";
    };

    launcher = mkOption {
      type = types.str;
      default = "";
    };

    theme = mkOption {
      type = with types; enum ["gruvbox" "tokyo-night" "arin" "none"];
    };
  };

  config = mkIf (cfg.enable) {
    home = {
      sessionVariables = {
        EDITOR = cfg.editor;
        GUI_EDITOR = cfg.guiEditor;
        VISUAL = cfg.editor;
        FILEMANAGER = cfg.fileManager;
        GUI_FILEMANAGER = cfg.guiFileManager;
        TERMINAL = cfg.terminal;
        GUI_TERMINAL = cfg.guiTerminal;
        LAUNCHER = cfg.launcher;
      };
      packages =
        cfg.extraPackages
        ++ [
        ];
    };
  };
}
