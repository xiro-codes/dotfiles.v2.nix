{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf types getExe;
  inherit (pkgs.formats) toml;
  toml' = toml {};

  inherit (pkgs) joshuto trash-cli unzip p7zip;
  global = config.local;
  local = config.local.joshuto;
  defaultSettings = import ./default_settings.nix {};
  defaultKeymap = import ./default_keymap.nix {};
  defaultIcons = import ./default_icons.nix {};
in {
  imports = [];
  options.local.joshuto = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    settings = mkOption {
      type = types.attrsOf types.anything;
      default = defaultSettings;
    };
    keymap = mkOption {
      type = types.attrsOf types.anything;
      default = defaultKeymap;
    };
    mimetype = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
    theme = mkOption {
      type = types.attrsOf types.anything;
      default = {};
    };
    icons = mkOption {
      type = types.attrsOf types.anything;
      default = defaultIcons;
    };
  };
  config = mkIf (local.enable) {
    local.fileManager = "${getExe joshuto}";

    home.packages = [
      joshuto
      trash-cli
      unzip
      p7zip
      (pkgs.writeShellScriptBin "hm-joshuto-preview-file" (builtins.readFile ./preview_file.sh))
    ];

    xdg.configFile."joshuto/joshuto.toml".source = toml'.generate "joshuto.toml" local.settings;
    xdg.configFile."joshuto/keymap.toml".source = toml'.generate "keymap.toml" local.keymap;
    xdg.configFile."joshuto/mimetype.toml".source = toml'.generate "mimetype.toml" local.mimetype;
    xdg.configFile."joshuto/theme.toml".source = toml'.generate "theme.toml" local.theme;
    xdg.configFile."joshuto/icons.toml".source = toml'.generate "icons.toml" local.icons;

    assertions = [
      {
        # todo: add the other file managers
        assertion = !config.local.ranger.enable || ! config.local.nnn.enable || ! config.local.lf.enable;
        message = "Only one file manager can be enabled at a time";
      }
    ];
  };
}
