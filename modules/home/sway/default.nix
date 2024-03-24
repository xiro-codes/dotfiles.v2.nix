{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
  lock = pkgs.writeShellScriptBin "lock" ''
    ${pkgs.swaylock-effects}/bin/swaylock --screenshots \
       --clock \
       --indicator \
       --datestr "%m-%d" \
       --effect-blur 7x5 \
       --ring-color 9AA5CE \
       --key-hl-color 9ECE6A \
       --text-color 7DCFFF \
       --line-color 00000000 \
       --inside-color 00000088 \
       --separator-color 00000000 \
       --fade-in 0.2 \
  '';
in {
  options.local.sway = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (cfg.sway.enable) {
    home.packages = [lock];

    xdg.configFile."sway/config".source = ./config.sway;

    systemd.user.targets.sway-session = {
      Unit = {
        Description = "sway session target";
      };
      Target = {
        After = "graphical.target";
      };
    };
  };
}
