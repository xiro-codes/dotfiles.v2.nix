{pkgs, ...}: [
  {
    "position" = "top";
    "height" = 30;
    "layer" = "top";
    "modules-left" = ["hyprland/workspaces"];
    "modules-right" = ["mpd" "network" "pulseaudio" "battery" "clock" "tray"];
    "hyprland/workspaces" = {
      "disable-scroll" = true;
      "all-outputs" = false;
      "persistent_workspaces" = {
        "1" = ["DP-2"];
        "2" = ["DP-2"];
        "3" = ["DP-2"];
        "4" = ["DP-3"];
        "5" = ["DP-3"];
        "6" = ["DP-3"];
      };
      "format" = "{icon}";
      "format-icons" = {
        "1" = "一";
        "2" = "二";
        "3" = "三";
        "4" = "四";
        "5" = "五";
        "6" = "六";
      };
    };
    "mpd" = {
      "format" = "{stateIcon} {consumeIcon}{randomIcon}{repeatIcon}{singleIcon}: Playing [{title}]";
      "format-stopped" = "{consumeIcon}{randomIcon}{repeatIcon}{singleIcon}🎧 No Song";
      "on-click" = "kitty --class mkitty ncmpcpp";
      "random-icons" = {
        "off" = "<span color='#f53c3c'></span>";
        "on" = " ";
      };
      "repeat-icons" = {
        "on" = " ";
      };
      "single-icons" = {
        "on" = "1 ";
      };
      "state-icons" = {
        "paused" = "";
        "playing" = "";
      };
    };
    "clock" = {
      "format" = " {:%H:%M}";
      "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      "format-alt" = "{:%Y-%m-%d}";
    };
    "network" = {
      "format-wifi" = "  {essid}";
      "format-ethernet" = "{ifname}: {ipaddr}/{cidr} ";
      "format-linked" = "{ifname} (No IP) ";
      "format-disconnected" = "⚠  Disconnected";
      "format-alt" = "{ifname}: {ipaddr}/{cidr}";
    };
    "pulseaudio" = {
      "format" = "{icon}  {volume}%";
      "format-muted" = " Muted";
      "format-icons" = {
        "headphone" = "";
        "hands-free" = "";
        "headset" = "";
        "phone" = "";
        "portable" = "";
        "car" = "";
        "default" = ["" "" ""];
      };
      "on-click" = "pavucontrol";
    };
    "tray" = {
      "icon-size" = 21;
      "spacing" = 10;
    };
  }
  {
    "position" = "bottom";
    "height" = 30;
    "layer" = "top";
    "modules-right" = [];
    "modules-center" = ["wlr/taskbar"];
    "modules-left" = ["cpu"];
    "cpu" = {
      "interval" = 2;
      "format" = " {icon0} {icon1} {icon2} {icon3} {icon4} {icon5} {icon6} {icon7} {icon8} {icon9} {icon10} {icon11} {icon12} {icon13} {icon14} {icon15} {icon16} {icon17} {icon18} {icon19} {icon20} {icon21} {icon22} {icon23} ";
      "format-icons" = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
    };
    "wlr/taskbar" = {
      "format" = "{icon}";
      "icon-size" = 14;
      "icon-theme" = "Numix-Circle";
      "tooltip-format" = "{title}";
      "on-click" = "activate";
      "on-click-middle" = "close";
    };
  }
]
