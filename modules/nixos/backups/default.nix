{
  pkgs,
  lib,
  inputs,
  config,
  ...
}: let
  cfg = config.local;
  self = cfg.backups;
  inherit (lib) getExe' mkOption mkIf mkMerge types mkDefault;
in {
  options.local.backups = {
    targets = mkOption {
      default = [];
      type = with types;
        listOf (submodule {
          options = {
            name = mkOption {type = str;};
            source = mkOption {type = str;};
            dest = mkOption {type = str;};
            format = mkOption {
              type = str;
              default = "+%Y-%m-%d@%H-%M-%S";
            };
          };
        });
    };
  };
  config.systemd = let
    services =
      map
      (t: {
        services."backup-${t.name}" = {
          script = "${getExe' pkgs.btrfs-progs "btrfs"} subvolume snapshot ${t.source} ${t.dest}.`date ${t.format}`";
          serviceConfig = {
            User = "root";
            Type = "oneshot";
          };
        };
        timers."backup-${t.name}" = {
          wantedBy = ["timers.target"];
          timerConfig = {
            OnBootSec = "5s";
            Unit = "backup-${t.source}.service";
          };
        };
      })
      config.local.backups.targets;
  in
    mkMerge services;
}
