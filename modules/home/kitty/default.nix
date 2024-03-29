{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types;
  cfg = config.local;
in {
  imports = [];
  options.local.kitty = {
    enable = mkOption {
      type = types.bool;
    };
  };
  config = mkIf (cfg.kitty.enable) {
    local.terminal = "${pkgs.kitty}/bin/kitty";
    programs.kitty = {
      enable = true;
      font = {
        package = pkgs.cascadia-code;
        name = "CascadiaCode";
        size = 10;
      };
      extraConfig = lib.readFile ./themes/${cfg.theme}.conf;
    };
  };
}
