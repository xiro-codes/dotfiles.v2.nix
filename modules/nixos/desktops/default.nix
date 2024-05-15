{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local;
  self = cfg.desktops;
  inherit (lib) mkOption mkIf mkForce;
  inherit (lib.types) bool;
  inherit (inputs) niri hyprland;
  command = ''
    ${pkgs.greetd.tuigreet}/bin/tuigreet --greeting "Welcome Home!" \
                                         --asterisks \
                                         --remember \
                                         --remember-user-session \
                                         --time \
                                         --sessions /etc/greetd/sessions
  '';
in {
  options.local.desktops = {
    enable = mkOption {
      type = bool;
      default = false;
    };
    useEnv = mkOption {
      type = bool;
      default = false;
    };
    enableHyprland = mkOption {
      type = bool;
      default = true;
    };
    enableNiri = mkOption {
      type = bool;
      default = false;
    };
    enableGreeter = mkOption {
      type = bool;
      default = true;
    };
    enablePlasma6 = mkOption {
      type = bool;
      default = false;
    };
  };
  config = mkIf self.enable {
    xdg.portal.enable = true;
    hardware.pulseaudio.enable = mkForce false;
    environment.systemPackages = with pkgs; [
      xdg-user-dirs
      xdg-utils
    ];
    environment.variables = mkIf cfg.desktops.useEnv {
      NIXOS_OZONE_WL = "1";
      CLUTTER_BACKEND = "wayland";
      GDK_BACKEND = "wayland";
      GDK_DPI_SCALE = "1";
      MOZ_ENABLE_WAYLAND = "1";
      QT_QPA_PLATFORM = "wayland";
      QT_QPA_PLATFORMTHEME = "qt5ct";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
      WLR_NO_HARDWARE_CURSORS = "1";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on";
      WARP_ENABLE_WAYLAND = "1";
    };

    users.users.greeter = {
      name = "greeter";
      isSystemUser = true;
      group = "greeter";
    };
    users.groups.greeter = {};

    programs = {
      hyprland = mkIf self.enableHyprland {
        enable = true;
        #package = hyprland.packages.${pkgs.system}.hyprland;
      };
    };
    local.programs = {
      hyprland = mkIf self.enableHyprland {
        greetd.enable = true;
      };
      niri = mkIf self.enableNiri {
        enable = true;
        package = niri.packages.${pkgs.system}.default;
        greetd.enable = true;
      };
      plasma6 = mkIf self.enablePlasma6 {
        enable = true;
        greetd.enable = true;
      };
    };
    services = {
      pipewire = {
        enable = true;
        pulse.enable = true;
        alsa.enable = true;
      };
      greetd = mkIf (self.enableGreeter){
        enable = true;
        vt = 2;
        settings = {
          default_session = {
            inherit command;
            user = "greeter";
          };
        };
      };
    };
  };
}
