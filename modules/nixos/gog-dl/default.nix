{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  cfg = config.local;
  self = cfg.gog-dl;
  inherit (lib) getExe mkOption mkIf mkMerge types mkDefault;
in {
  options.local.gog-dl = {
    user = mkOption {
      default = "tod";
      type = types.str;
    };
    group = mkOption {
      default = "users";
      type = types.str;
    };
  };
}
