{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
in {
  options.local.mako.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf (cfg.mako.enable) {
    services.mako = {
      enable = true;
      anchor = "top-right";
      layer = "overlay";
      backgroundColor = "#FFFFFF";
      textColor = "#1e1e1e";
      width = 350;
      height = 60;
      margin = "4,68,0";
      padding = "2";
      borderSize = 2;
      borderColor = "#1e1e1e";
      borderRadius = 10;
      defaultTimeout = 10000;
      groupBy = "summary";
    };
  };
}
