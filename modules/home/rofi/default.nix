{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  inherit (pkgs) writeShellScriptBin writeShellApplication;
  inherit (builtins) readFile;
  cfg = config.local;
  mkShellBin = name: file: writeShellScriptBin name (readFile file);

  rofi-wifi = mkShellBin "rofi-wifi" ./scripts/wifi.sh;

  rofi-wifi' = writeShellApplication {
    name = "rofi-wifi";
    runtimeInputs = [
      pkgs.iwd
      pkgs.coreutils
      pkgs.rofi-wayland
      pkgs.gnused
      pkgs.gawk
      pkgs.gnugrep
    ];
    checkPhase = "";
    text = readFile ./scripts/wifi.sh;
  };
  #rofi-bluetooth = mkShellBin "rofi-bluetooth" ./scripts/bluetooth.sh;
  rofi-bluetooth' = writeShellApplication {
    name = "rofi-bluetooth";
    runtimeInputs = [
      pkgs.rofi-wayland
      pkgs.bluez
      pkgs.gawk
      pkgs.gnugrep
      pkgs.coreutils
    ];
    checkPhase = "";
    text = import ./scripts/bluetooth.sh.nix {inherit pkgs;};
  };
  rofi-powermenu = mkShellBin "rofi-powermenu" ./scripts/powermenu.sh;
in {
  options.local.rofi.enable = mkOption {
    type = types.bool;
    default = cfg.hyprland.enable;
  };
  config = mkIf cfg.rofi.enable {
    home.packages = with pkgs; [rofi-wifi' rofi-bluetooth' rofi-powermenu];
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = ./themes/arin/arin.rasi;
    };
    local.launcher = "${config.programs.rofi.finalPackage}/bin/rofi";
    #local.wifi = "${rofi-wifi'}/bin/rofi-wifi";
    #local.bluetooth = "${rofi-bluetooth'}/bin/rofi-bluetooth";
  };
}
