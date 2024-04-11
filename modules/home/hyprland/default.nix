{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  inherit (inputs.self.packages.${pkgs.system}) hyprland-scripts;
  inherit (inputs.self.lib) reduce;
  cfg = config.local;

  variables = config.home.sessionVariables;
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
        libnotify
        cliphist
      ]
      ++ [hyprland-scripts];

    systemd.user.services.monitors-hook = {
      Unit = {
        Description = "Relaunh hud on monitor change";
      };
      Install = {
        WantedBy = ["hyprland-session.target"];
      };
      Service = {
        ExecStart = "${hyprland-scripts}/bin/wm-monitors-hook";
        Restart = "always";
      };
    };
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        general = {
          layout = "master";
          border_size = "2";
          "col.active_border" = "rgba(33ccffee)";
          "col.inactive_border" = "rgba(595959aa)";
          "gaps_in" = "2";
          "gaps_out" = "68,4,4,70";
        };
        input = {
          follow_mouse = "1";
          mouse_refocus = false;
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
        "$mod" = "SUPER_L";
        "$super" = "ALT_L";

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
          "${getExe hyprland-scripts}"
          ''${pkgs.swayidle}/bin/swayidle lock "${hyprland-scripts}/bin/wm-lock"''
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
          "$mod, Return, exec, ${variables.GUI_TERMINAL}"
          "$mod_SHIFT, Return, exec, ${variables.TERMINAL}"

          "$mod, E, exec, ${variables.GUI_FILEMANAGER}"
          "$mod_SHIFT, E, exec, ${variables.FILEMANAGER}"

          "$mod, P, exec, ${variables.LAUNCHER} -show drun -show-icons"

          "$mod, Space, layoutmsg, swapwithmaster master"

          "$mod_SHIFT, Q, killactive"

          "$mod, Backspace, exec, ${hyprland-scripts}/bin/wm-show_dash"

          "$mod, F, fullscreen"
          "$mod_SHIFT, F, togglefloating"

          "$mod, H, movefocus, l"
          "$mod, J, movefocus, d"
          "$mod, K, movefocus, u"
          "$mod, L, movefocus, r"

          "$super, J, layoutmsg, cyclenext"

          "$super, K, layoutmsg, cycleprev"

          "$mod_SHIFT, J, layoutmsg, swapnext"
          "$mod_SHIFT, K, layoutmsg, swapprev"
          #"$mod_SHIFT, H, movewindow, l"
          #"$mod_SHIFT, J, movewindow, d"
          #"$mod_SHIFT, K, movewindow, u"
          #"$mod_SHIFT, L, movewindow, r"

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
  };
}
