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
    "modules-right" = [
      "hyprland/workspaces"
    ];
    "hyprland/workspaces" = {
      "disable-scroll" = true;
      "all-outputs" = false;
      "format" = "{icon}";
      "persistent-workspaces" = {
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
  }
]
