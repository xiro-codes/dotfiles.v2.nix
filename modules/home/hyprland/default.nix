{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.local;
  variables = config.home.sessionVariables;
  hide_waybar = pkgs.writeShellScriptBin "hide_waybar" ''
		kill -SIGUSR1 $(pidof waybar)
	'';
  reduce = f: list: (foldl f (head list) (tail list));

  sunset = pkgs.writeShellScriptBin "sunset" ''
    ${pkgs.wlsunset}/bin/wlsunset -S 6:00 -s 17:00
  '';
  swaylock = pkgs.writeShellScriptBin "swaylock" ''
    ${pkgs.swaylock-effects}/bin/swaylock --screenshots \
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

  launch_hud = pkgs.writeShellScriptBin "launch_hud" ''
		${pkgs.eww}/bin/eww open-many --toggle apps apps1 clock clock1 music music1
  '';

  launch_dash = pkgs.writeShellScriptBin "launch_dash" ''
		${pkgs.eww}/bin/eww open-many --toggle resources quotes logout lock shutdown suspend reboot; 
  '';

	show_dash = pkgs.writeShellScriptBin "show_dash" ''
		${pkgs.eww}/bin/eww open-many --toggle resources quotes logout lock shutdown suspend reboot; 
		sleep 10;
		${pkgs.eww}/bin/eww close resources quotes logout lock shutdown suspend reboot; 
	'';

	hyprland_scripts = pkgs.symlinkJoin { name = "hyprland_scripts"; paths = [ show_dash launch_hud launch_dash swaylock sunset]; postBuild = "echo links added"; };
in {
  options.local.hyprland = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
    wallpaperPath = mkOption {
      type = types.str;
      default = "~/.wallpaper";
    };

    monitors = mkOption {
      default = [];
      type = with types;
        listOf (submodule {
          options = {
            enabled = mkOption {
              type = bool;
              default = true;
            };
            name = mkOption {type = str;};
            width = mkOption {type = int;};
            height = mkOption {type = int;};
            rate = mkOption {type = int;};
            scale = mkOption {type = int;};
            x = mkOption {type = int;};
            y = mkOption {type = int;};
            workspaces = mkOption {type = listOf int;};
          };
        });
    };
  };
  config = mkIf (cfg.hyprland.enable) {
    home.packages = with pkgs;
      [
        wl-clipboard
        espeak
        libnotify
        cliphist
        wtype
        bc
      ]
      ++ [
				hyprland_scripts
      ];
    wayland.windowManager = {
      hyprland.enable = true;
      hyprland.systemd.enable = true;
      hyprland.extraConfig = ''
        input {
          follow_mouse = 1
          mouse_refocus = false
        }
      '';
      hyprland.settings = {
        general = {
          layout = "master";
          border_size = "2";
          "col.active_border" = "rgba(33ccffee)";
          "col.inactive_border" = "rgba(595959aa)";
          "gaps_in" = "2";
          "gaps_out" = "68,4,4,70";
        };
        master = {
          new_is_master = false;
          mfact = "0.65";
        };
        decoration = {
          rounding = "4";
          shadow_offset = "0 4";
          "col.shadow" = "rgba(00000099)";
          inactive_opacity = "0.7";
          active_opacity = "1.0";
          fullscreen_opacity = "1";
        };
        "$mod" = "ALT_L";
        "$super" = "SUPER_L";

        windowrule = [
          "float, ^(mkitty)$"
          "float, ^(pavucontrol)$"
          "float, ^(pcmanfm)$"
          "float, ^(discord)$"
          "float, ^(fkitty)$"
          "float, ^(swayimg)$"
          "float, ^(feh)$"
          "float, title:^(btop)"
          "float, title:^(game)"
          "float, title:^(Dioxus app)"
          "nofocus, com-group_finity-mascot-Main"
          "noblur, com-group_finity-mascot-Main"
          "noshadow, com-group_finity-mascot-Main"
          "noborder, com-group_finity-mascot-Main"
          "float, com-group_finity-mascot-Main"
        ];
        exec-once = [
          "wl-paste --type text --watch cliphist store"
          "steam -silent"
          "${sunset}/bin/sunset"
          "${pkgs.swaybg}/bin/swaybg -i ${cfg.hyprland.wallpaperPath}"
          ''${pkgs.swayidle}/bin/swayidle lock "${swaylock}/bin/swaylock"''
					''${launch_hud}/bin/launch_hud''
        ];
        monitor =
          map
          (m: let
            resolution = "${toString m.width}x${toString m.height}@${toString m.rate}";
            position = "${toString m.x}x${toString m.y}";
          in "${m.name},${
            if m.enabled
            then "${resolution},${position},${toString m.scale}"
            else "disable"
          }")
          (cfg.hyprland.monitors);

        workspace = reduce (cs: s: cs ++ s) (map (m: map (w: "${m.name}, ${toString w}") m.workspaces) (cfg.hyprland.monitors));

        bind = [
          "$mod, Return, exec, warp-terminal-wayland"
          "$mod, E, exec, ${variables.FILEMANAGER}"
					"$mod, X, exec, ${hide_waybar}/bin/hide_waybar"
          "$mod, P, exec, ${variables.LAUNCHER} -show drun -show-icons"
          "$mod, Space, layoutmsg, swapwithmaster master"

          "$mod_SHIFT, Q, killactive"
			
          "$mod, Backspace, exec, ${show_dash}/bin/show_dash"

          "$mod, F, fullscreen"
          "$mod_SHIFT, F, togglefloating"

          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          "$mod_SHIFT, H, movewindow, l"
          "$mod_SHIFT, J, movewindow, d"
          "$mod_SHIFT, K, movewindow, u"
          "$mod_SHIFT, L, movewindow, r"

          "$mod, U, workspace, 1"
          "$mod, I, workspace, 2"
          "$mod, O, workspace, 3"

          "$mod_SHIFT, U, movetoworkspace, 1"
          "$mod_SHIFT, I, movetoworkspace, 2"
          "$mod_SHIFT, O, movetoworkspace, 3"

          "$mod, M, workspace, 4"
          "$mod, comma, workspace, 5"
          "$mod, period, workspace, 6"

          "$mod_SHIFT, M, movetoworkspace, 4"
          "$mod_SHIFT, comma,   movetoworkspace, 5"
          "$mod_SHIFT, period, movetoworkspace, 6"
        ];
        bindm = [
          "$mod,mouse:272, movewindow"
          "$mod,mouse:273, resizewindow"
        ];
      };
    };
    assertions = [
      {
        assertion = config.local.rofi.enable;
        message = "hyprland depends on rofi";
      }
    ];
  };
}
