{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.programs.niri;
  inherit (lib) mkOption mkIf mkPackageOption;
  inherit (lib.types) bool;
in {
  options.local.programs.niri = {
    enable = mkOption {
      type = bool;
      default = false;
    };
    package = mkPackageOption pkgs "niri" {};
    greetd.enable = mkOption {
      type = bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.package
      ];
      etc."greetd/sessions/niri.desktop".text = mkIf cfg.greetd.enable ''
        [Desktop Entry]
            Name=Niri
            Comment=Niri A Scrolling Window Manager built on Smithay
            Exec=${cfg.package}/bin/niri
      '';
    };
  };
}
