{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.local.eww;
in {
  options.local.eww.enable = mkEnableOption "eww";
  config = mkIf cfg.enable {
    # configuration
    home.packages = [
      pkgs.eww
      pkgs.pamixer
      pkgs.brightnessctl
      pkgs.lua
			pkgs.ffmpeg
			pkgs.socat
    ];
    home.file.".config/eww/eww.scss".source = ./eww.scss;
    home.file.".config/eww/eww.yuck".source = ./eww.yuck;
    home.file.".config/eww/images/".source = ./images;


    # scripts
    home.file.".config/eww/scripts/sys_info" = {
      source = ./scripts/sys_info;
      executable = true;
    };
    home.file.".config/eww/scripts/change-active-workspace" = {
      source = ./scripts/change-active-workspace;
      executable = true;
    };
    home.file.".config/eww/scripts/get-active-workspace" = {
      source = ./scripts/get-active-workspace;
      executable = true;
    };
    home.file.".config/eww/scripts/get-workspaces" = {
      source = ./scripts/get-workspaces;
      executable = true;
    };
    home.file.".config/eww/scripts/get-window-title" = {
      source = ./scripts/get-window-title;
      executable = true;
    };
		home.file.".config/eww/scripts/widget_apps" = {
      source = ./scripts/widget_apps;
      executable = true;
			};
    home.file.".config/eww/scripts/battery" = {
      source = ./scripts/battery;
      executable = true;
    };
    home.file.".config/eww/scripts/check-network" = {
      source = ./scripts/check-network;
      executable = true;
    };
    home.file.".config/eww/scripts/mails" = {
      source = ./scripts/mails;
      executable = true;
    };
    home.file.".config/eww/scripts/music_info" = {
      source = ./scripts/music_info;
      executable = true;
    };
    home.file.".config/eww/scripts/weather_info" = {
      source = ./scripts/weather_info;
      executable = true;
    };
    home.file.".config/eww/scripts/quotes" = {
      source = ./scripts/quotes;
      executable = true;
    };
    home.file.".config/eww/scripts/system" = {
      source = ./scripts/system;
      executable = true;
    };
    home.file.".config/eww/scripts/volume" = {
      source = ./scripts/volume;
      executable = true;
    };
  };
}
