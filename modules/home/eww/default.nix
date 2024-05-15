{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.eww;
  scripts = inputs.self.packages.${pkgs.system}.eww-scripts;
in {
  options.local.eww.enable = mkEnableOption "eww";
  config = mkIf cfg.enable {
    # configuration
    home.packages = [
      pkgs.eww
      inputs.self.packages.${pkgs.system}.eww-scripts
    ];
    home.file = {
      ".config/eww/eww.scss".source = ./eww.scss;
      ".config/eww/eww.yuck".source = ./eww.yuck;
      ".config/eww/images/".source = ./images;
    };

    systemd.user.timers = {
      weather_info = {
        Unit.Description = "Get Weather for eww widget";
        Timer = {
          Unit = "weather_info";
          OnBootSec = "1m";
          OnUnitActiveSec = "1m";
        };
        Install.WantedBy = ["timers.target"];
      };
    };
    systemd.user.services = {
      weather_info = {
        Unit = {Description = "Get Weather for eww widget";};
        Service = {
          Type = "oneshot";
          ExecStart = "${scripts}/bin/eww-weather_info --getdata";
        };
        Install.WantedBy = ["default.target"];
      };
    };

    assertions = [
      {
        assertion = config.local.mpd.enable;
        message = "Require mpd for all music player feature";
      }
    ];
  };
}
