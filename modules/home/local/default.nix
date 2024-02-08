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
    fileManager = mkOption {type = types.str;};
    terminal = mkOption {type = types.str;};
    launcher = mkOption {type = types.str;};
    wifi = mkOption {type = types.str;};
    bluetooth = mkOption {type = types.str;};
		theme = mkOption {
			type = with types; enum ["gruvbox" "tokyo-night" "arin"] ;
		};
  };

  config = mkIf (cfg.enable) {
    home = {
      sessionVariables = {
        EDITOR = cfg.editor;
        VISUAL = cfg.editor;
        FILEMANAGER = cfg.fileManager;
        TERMINAL = cfg.terminal;
        LAUNCHER = cfg.launcher;
        WIFI = cfg.wifi;
        BLUETOOTH = cfg.bluetooth;
      };
      packages =
        cfg.extraPackages
        ++ [
        ];
    };
  };
}
