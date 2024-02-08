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
  options.local.nnn = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (cfg.nnn.enable) {
    programs.nnn.enable = true;
    local.fileManager = "${config.programs.nnn.finalPackage}/bin/nnn";
  };
}
