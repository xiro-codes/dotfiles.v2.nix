{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  inherit (pkgs) callPackage;
  cfg = config.local;
in {
  options.local.waybar = {
    enable = mkOption {
      type = types.bool;
      default = cfg.hyprland.enable;
    };
  };

  config = mkIf (cfg.waybar.enable) {
    home.packages = with pkgs; [pavucontrol jq wttrbar];
    programs.waybar = {
      enable = true;
      package = inputs.stable.legacyPackages.${pkgs.system}.waybar;
      systemd = {
        enable = true;
        target = "hyprland-session.target";
      };
      settings = callPackage ./themes/${cfg.theme}/config.nix {inherit pkgs cfg inputs;};
      style = ./themes/${cfg.theme}/style.css;
    };
  };
}
