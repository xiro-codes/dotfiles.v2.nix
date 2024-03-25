{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf types getExe;
  inherit (pkgs.formats) toml;
  inherit (pkgs) joshuto;
  global = config.local;
  local = config.local.joshuto;
  defaultSettings = import ./default_settings.nix {};
  defaultKeymap = import ./default_keymap.nix {};
in {
  imports = [];
  options.local.joshuto = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    settings = mkOption {
      type = types.attrsOf types.any;
      default = defaultSettings;
    };
    keymap = mkOption {
      type = types.attrsOf types.any;
      default = defaultKeymap;
    };
    mimetype = mkOption {
      type = types.attrsOf types.any;
      default = {};
    };
    theme = mkOption {
      type = types.attrsOf types.any;
      default = {};
    };
    icons = mkOption {
      type = types.attrsOf types.any;
      default = {};
    };
  };
  config = mkIf (local.enable) {
    local.fileManager = "${getExe joshuto}";

    home.packages = [joshuto (pkgs.writeShellScriptBin "joshuto-preview_file" (builtins.readFile ./preview_file.sh))];

    xdg.configFile."joshuto/joshuto.toml".source = toml.generate "joshuto.toml" local.settings;
    xdg.configFile."joshuto/keymap.toml".source = toml.generate "keymap.toml" local.keymap;
    xdg.configFile."joshuto/mimetype.toml".source = toml.generate "mimetype.toml" local.mimetype;
    xdg.configFile."joshuto/theme.toml".source = toml.generate "theme.toml" local.theme;
    xdg.configFile."joshuto/icons.toml".source = toml.generate "icons.toml" local.theme;
  };

  assertions = [
    {
      assertion = !config.local.ranger.enable || ! config.local.nnn.enable;
      message = "Only enable one file manger ";
    }
  ];
}
