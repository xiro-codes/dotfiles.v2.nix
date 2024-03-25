{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.local;
in {
  imports = [];
  options.local.ranger = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (cfg.ranger.enable) {
    home.packages = [pkgs.ranger];
    xdg.configFile = {
      "ranger/rifle.conf".source = ./rifle.conf;
      "ranger/rc.conf".source = ./rc.conf;
      "ranger/plugins/ranger_devicons".source = ./ranger_devicons;
    };
  };
}
