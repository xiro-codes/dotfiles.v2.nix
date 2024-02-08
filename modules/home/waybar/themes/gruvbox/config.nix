{
  pkgs,
  cfg,
  inputs,
}: [
  {
    "layer" = "top";
    "position" = "top";
    "mod" = "dock";
    "exclusive" = true;
    "passtrough" = false;
    "gtk-layer-shell" = true;
    "height" = 40;
    "modules-left" = [
      "clock"
      "network"
      "cpu"
      "memory"
      "hyprland/workspaces"
    ];
    "modules-center" = ["hyprland/window"];
    "modules-right" = [
      "tray"

      "custom/hdhomerun_status0"
      "custom/hdhomerun_status1"
      "custom/hdhomerun_status2"
      "custom/hdhomerun_status3"

      "wireplumber"
      "bluetooth"
      "mpd"
    ];
    "network" = {
      "format-wifi" = " {ipaddr}";
      "format-ethernet" = "󰈀 {ipaddr}";
      "format-linked" = "{ifname} (No IP) ";
      "format-disconnected" = "⚠  Disconnected";
      "tooltip-format" = "{ifname}: {ipaddr}";
      "on-click" = "${cfg.wifi}";
    };
    "hyprland/window" = {
      "format" = "{}";
    };
    "bluetooth" = {
      "format-on" = "";
      "format-off" = "󰂲";
      "format-connected" = "󰂱 {num_connections}";
      "on-click" = "${cfg.bluetooth}";
    };
    "mpd" = {
      "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}: Playing [{title}]";
      "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}🎧 No Song";
      "random-icons" = {
        "on" = " ";
      };
      "repeat-icons" = {
        "on" = " ";
      };
      "single-icons" = {
        "on" = "1";
      };
      "state-icons" = {
        "paused" = "";
        "playing" = "";
      };
    };
    "idle_inhibitor" = {
      "format" = "{icon}";
      "format-icons" = {
        "activated" = "";
        "deactivated" = "";
      };
    };
    "custom/weather" = {
      "format" = "{} °";
      "tooltip" = true;
      "interval" = 3600;
      "exec" = "${pkgs.wttrbar}/bin/wttrbar --fahrenheit --main-indicator 'temp_F'";
      "return-type" = "json";
    };
    "hyprland/workspaces" = {
      "disable-scroll" = true;
      "all-outputs" = false;
      "format" = "{icon}";
      "persistent_workspaces" = {
        "1" = ["DP-1"];
        "2" = ["DP-1"];
        "3" = ["DP-1"];
        "4" = ["DP-2"];
        "5" = ["DP-2"];
        "6" = ["DP-2"];
      };
      "format-icons" = {
        "1" = "一";
        "2" = "二";
        "3" = "三";
        "4" = "四";
        "5" = "五";
        "6" = "六";
      };
    };
    "cpu" = {
      "interval" = 10;
      "format" = " {}%";
      "max-length" = 10;
    };
    "custom/hdhomerun_status0" = {
      "return-type" = "json";
      "interval" = 5;
      "format" = "{}";
      "exec" = "${inputs.self.packages.x86_64-linux.hdhomerun_status}/bin/hdhomerun_status --tuner 0 10.0.0.3";
    };
    "custom/hdhomerun_status1" = {
      "return-type" = "json";
      "interval" = 5;
      "format" = "{}";
      "exec" = "${inputs.self.packages.x86_64-linux.hdhomerun_status}/bin/hdhomerun_status --tuner 1 10.0.0.3";
    };
    "custom/hdhomerun_status2" = {
      "return-type" = "json";
      "interval" = 5;
      "format" = "{}";
      "exec" = "${inputs.self.packages.x86_64-linux.hdhomerun_status}/bin/hdhomerun_status --tuner 2 10.0.0.3";
    };
    "custom/hdhomerun_status3" = {
      "return-type" = "json";
      "interval" = 5;
      "format" = "{}";
      "exec" = "${inputs.self.packages.x86_64-linux.hdhomerun_status}/bin/hdhomerun_status --tuner 3 10.0.0.3";
    };
    "memory" = {
      "interval" = 30;
      "format" = " {}%";
      "format-alt" = " {used:0.1f}G";
      "max-length" = 10;
    };
    "tray" = {
      "icon-size" = 13;
      "tooltip" = false;
      "spacing" = 10;
    };
    "clock" = {
      "format" = "{: %R   %d/%m}";
      "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
    };
    "wireplumber" = {
      "format" = "{icon} {volume}%";
      "tooltip" = false;
      "on-click" = "${pkgs.helvum}/bin/helvum";
      "format-muted" = " Muted";
      "format-icons" = {
        "headphone" = "";
        "hands-free" = "";
        "headset" = "";
        "phone" = "";
        "portable" = "";
        "car" = "";
        "default" = ["" "" ""];
      };
    };
  }
]
