{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local.programs.plasma6;
  inherit (lib) mkOption mkIf mkPackageOption;
  inherit (lib.types) bool;
in {
  options.local.programs.plasma6 = {
    enable = mkOption {
      type = bool;
      default = false;
    };
    greetd.enable = mkOption {
      type = bool;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    environment = mkIf cfg.greetd.enable {
      etc = {
        "/greetd/sessions/plasma6.desktop".text = ''
          [Desktop Entry]
          Name=Plasma6
          Comment=KDE Plasma6
          Exec=${pkgs.kdePackages.plasma-workspace}/bin/startplasma-wayland
        '';
      };
    };
    services.xserver.desktopManager.plasma6.enable = true;
  };
}
