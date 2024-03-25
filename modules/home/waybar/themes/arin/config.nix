{
  pkgs,
  cfg,
  inputs,
}: [
  {
    "layer" = "top";
    "position" = "top";
    "mod" = "dock";
    "exclusive" = false;
    "passtrough" = false;
    "gtk-layer-shell" = true;
    "height" = 64;
    "modules-left" = [
      #"cpu"
      #"memory"
    ];
    "modules-center" = [
    ];
    "modules-right" = [
      "hyprland/workspaces"
    ];
    "network" = {
      "format-wifi" = " {ipaddr}";
      "format-ethernet" = "󰈀 {ipaddr}";
      "format-linked" = "{ifname} (No IP) ";
      "format-disconnected" = "⚠  Disconnected";
      "tooltip-format" = "{ifname}: {ipaddr}";
    };
    "hyprland/window" = {
      "format" = "{class}";
      "separate-outputs" = true;
      "rewrite" = {
        "^dev.warp.Warp$" = " Warp";
        "^Google-chrome$" = " Chrome";
        "^Steam$" = " Steam";
        "^libreWolf$" = " LibreWolf";
        "^obsidian$" = "󰠮 Obsidian";
        "^steam_app_1042550$" = " Digimon Cyber Sleuth";
        "^steam_app_899770$" = " Last Epoch";
        "^steam_app_(.*)$" = " Steam [$1]";
      };
      "max-length" = "20";
    };
    "bluetooth" = {
      "format-on" = "";
      "format-off" = "󰂲";
      "format-connected" = "󰂱 {num_connections}";
    };
    "mpd" = {
      "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}: Playing";
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
      "persistent-workspaces" = {
        "1" = ["DP-1"];
        "2" = ["DP-1"];
        "3" = ["DP-1"];
        "4" = ["HDMI-A-1"];
        "5" = ["HDMI-A-1"];
        "6" = ["HDMI-A-1"];
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
