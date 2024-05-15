{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.local;
  self = cfg.networking;
  inherit (lib) mkOption mkIf types;
in {
  options.local.networking = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable local networking configuration.";
    };
  };
  config = mkIf (self.enable) {
    networking = {
      useDHCP = false;
      firewall.enable = true;
      networkmanager = {
        enable = true;
        wifi.backend = "iwd";
      };
      wireless = {
        enable = false;
        iwd.enable = true;
      };
    };
  };
}
