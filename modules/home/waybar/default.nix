{
  pkgs,
  config,
  lib,
  inputs,
  ...
}:
with lib; let
  cfg = config.local;

  hide_waybar = pkgs.writeShellScriptBin "hide_waybar" "kill -SIGUSR1 $(pidof waybar)";
in {
  options.local.waybar = {
    enable = mkOption {
      type = types.bool;
      default = cfg.hyprland.enable;
    };
    theme = mkOption {
      type = with types; enum ["gruvbox" "tokyo-night" "arin"];
      default = "gruvbox";
    };
  };
  config = mkIf (cfg.waybar.enable) {
    home.packages = with pkgs; [pavucontrol jq wttrbar];
    programs.waybar = {
      enable = true;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = pkgs.callPackage ./themes/${cfg.waybar.theme}/config.nix {inherit pkgs cfg inputs;};
      style = ./themes/${cfg.waybar.theme}/style.css;
    };
  };
}
