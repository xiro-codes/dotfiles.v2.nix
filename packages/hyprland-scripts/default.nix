{
  lib,
  pkgs,
  symlinkJoin,
  writeShellApplication,
  writeShellScriptBin,
  inputs,
  ...
}: let
  inherit (lib) getExe;
  prefix = "wm";
  sunset = writeShellApplication {
    name = "${prefix}-sunset";
    runtimeInputs = [pkgs.wlsunset];
    text = ''
      wlsunset -S 6:00 -s 17:00
    '';
  };
  monitors_hook = writeShellApplication {
    name = "${prefix}-monitors-hook";
    runtimeInputs = [pkgs.socat];
    text = ''
        handle() {
          case "$1" in
      monitoraddedv2*) ${getExe launch_full_hud};;
          esac
        }

        socat -U - UNIX-CONNECT:/tmp/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do handle "$line"; done
    '';
  };
  lock = writeShellApplication {
    name = "${prefix}-lock";
    runtimeInputs = [pkgs.swaylock-effects];
    text = ''
      swaylock --screenshots \
      				 --clock \
      				 --indicator \
      				 --datestr "%m-%d" \
      				 --effect-blur 7x5 \
      				 --ring-color 282828\
      				 --key-hl-color 9ECE6A \
      				 --text-color 7DCFFF \
      				 --line-color 00000000 \
             		 --inside-color 00000088 \
             		 --separator-color 00000000 \
             		 --effect-pixelate 40
    '';
  };

  launch_full_hud = pkgs.writeShellScriptBin "${prefix}-launch_hud" ''
    ${getExe pkgs.eww} open-many apps apps1 clock clock1 music music1
  '';
  open_full_hud = pkgs.writeShellScriptBin "${prefix}-open-hud" ''
    ${getExe pkgs.eww} open-many apps apps1 clock clock1 music music1
  '';
  close_full_hud = pkgs.writeShellScriptBin "${prefix}-close-hud" ''
    ${getExe pkgs.eww} close apps apps1 clock clock1 music music1
  '';

  launch_hud_0 = pkgs.writeShellScriptBin "${prefix}-launch_hud_0" ''
    ${getExe pkgs.eww} open-many --toggle apps clock music
  '';

  launch_hud_1 = pkgs.writeShellScriptBin "${prefix}-launch_hud_1" ''
    ${getExe pkgs.eww} open-many --toggle apps1 clock1 music1
  '';

  launch_dash = writeShellScriptBin "${prefix}-launch_dash" ''
    ${getExe pkgs.eww} open-many --toggle resources quotes logout lock shutdown suspend reboot;
  '';

  show_dash = writeShellScriptBin "${prefix}-show_dash" ''
    ${getExe pkgs.eww} open-many --toggle resources quotes logout lock shutdown suspend reboot;
    sleep 10;
    ${getExe pkgs.eww} close resources quotes logout lock shutdown suspend reboot;
  '';

  random_wallpaper = pkgs.writeShellScriptBin "${prefix}-random_wallpaper" ''
    ${getExe pkgs.swaybg} -i $HOME/Pictures/Wallpapers/$(ls $HOME/Pictures/Wallpapers | shuf -n 1)
  '';
  autostart = writeShellApplication {
    name = "${prefix}-autostart";
    runtimeInputs = with pkgs; [];
    text = ''
      ${getExe sunset} &
      ${getExe launch_full_hud};
      ${getExe random_wallpaper};
    '';
  };
in
  symlinkJoin {
    name = "hyprland-scripts";
    paths = [
      sunset
      lock
      open_full_hud
      close_full_hud
      launch_full_hud
      launch_hud_0
      launch_hud_1
      launch_dash
      show_dash
      random_wallpaper
      autostart
      monitors_hook
    ];
    meta.mainProgram = "${prefix}-autostart";
  }
