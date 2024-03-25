{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.programs.hyprland;
  inherit (lib) mkOption mkIf mkPackageOption;
  inherit (lib.types) bool;
in {
  options.local.programs.hyprland = {
    greetd.enable = mkOption {
      type = bool;
      default = false;
    };
  };
  config = mkIf config.programs.hyprland.enable {
    security.pam.services.swaylock = {};
    environment = {
      etc."greetd/sessions/hyprland.desktop".text = mkIf cfg.greetd.enable ''
        [Desktop Entry]
            Name=Hyprland
            Comment=Hyprland Session for greetd
            Exec=${config.programs.hyprland.finalPackage}/bin/Hyprland
      '';
    };
  };
}
