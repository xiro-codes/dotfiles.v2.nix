{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types mkIf;
  cfg = config.local.fonts;
in {
  options.local.fonts = {
    enable = mkOption {
      type = types.bool;
    };
  };
  config = mkIf (cfg.enable) {
    home.packages = with pkgs; [
      nerdfonts
    ];
    fonts.fontconfig.enable = true;
  };
}
