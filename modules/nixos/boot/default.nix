{ pkgs, config, lib, inputs, ... }:
let
  cfg = config.local;
  self = cfg.boot;

  inherit (lib) mkOption mkIf mkMerge types mkDefault;
in
{
  options.local.boot = {
    timeout = mkOption { type = types.int; default = 5; };
  };
  config = {
    boot.loader.timeout = self.timeout;
  };
}
