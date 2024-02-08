{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
  variables = config.home.sessionVariables;
  hide_waybar = pkgs.writeShellScriptBin "hide_waybar" "kill -SIGUSR1 $(pidof waybar)";
  reduce = f: list: (foldl f (head list) (tail list));

  sunset = pkgs.writeShellScriptBin "sunset" ''
    ${pkgs.wlsunset}/bin/wlsunset -S 6:00 -s 17:00
  '';
  paste-menu = pkgs.writeShellScriptBin "paste-menu" ''
    wtype "$(cliphist list | rofi -dmenu | cliphist decode )"
  '';
  tts-menu = pkgs.writeShellScriptBin "tts-menu" ''
    espeak "$( cliphist list | rofi -dmenu | cliphist decode )"
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
  idle = pkgs.writeShellScriptBin "idle" ''
    ${pkgs.swayidle}/bin/swayidle lock "${swaylock}/bin/swaylock"
  '';
  disable = pkgs.writeShellScriptBin "disable" ''
    hyprctl dispatch submap clean && \
    notify-send -w "Keybinds disabled dismiss to Renable" -t 0 && \
    notify-send -w "Keybinds Renabled $(hyprctl dispatch submap reset)"
  '';
in {
  options.local.niri = {
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
        easyeffects
        cliphist
        wtype
        wlogout
        bc
        swayidle
      ]
      ++ [
        paste-menu
        tts-menu
        hide_waybar
        swaylock
        idle
        disable
      ];
    xdg.configFile."niri/config.kdl".text = import ./niri.config.nix {  
				inherit pkgs; 
				monitors = cfg.niri.monitors; 
				wallpaperPath = cfg.niri.wallpaperPath; 
		};
  };
}
