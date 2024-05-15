{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local;
  self = cfg.bluetooth;
  inherit (lib) mkOption mkIf types;
in {
  options.local.bluetooth = {
    enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable Bluetooth support";
    };
  };
  config = mkIf (self.enable) {
    hardware.bluetooth = {
      enable = true;
      input.General.ClassicBondedOnly = false;
      settings.General.Experimental = true;
    };
  };
}
