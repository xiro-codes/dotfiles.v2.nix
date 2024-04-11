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
    systemd.user.timers = {
      refresh = {
        Unit.Description = "Refresh eww widget";
        Timer = {
          Unit = "refresh";
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
          ExecStart = "${scripts}/bin/weather_info --getdata";
        };
        Install.WantedBy = ["default.target"];
      };
    };
    systemd.user.services = {
      refresh = {
        Unit = {Description = "refresh hud";};
        Service = {
          Type = "oneshot";
          ExecStart = let
            scripts = inputs.self.packages.${pkgs.system}.hyprland-scripts;
          in ''
            ${scripts}/bin/wm-close-hud
          '';
          ExecStartPost = let
            scripts = inputs.self.packages.${pkgs.system}.hyprland-scripts;
          in ''
            ${scripts}/bin/wm-open-hud
          '';
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
