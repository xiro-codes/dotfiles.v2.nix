{
  lib,
  pkgs,
  symlinkJoin,
  writeShellApplication,
  writeShellScriptBin,
  ...
}: let
  inherit (lib) getExe;
  prefix = "eww";
  music_info = writeShellApplication {
    name = "${prefix}-music_info";
    runtimeInputs = [pkgs.ffmpeg pkgs.mpc-cli];
    text = builtins.readFile ./music_info.sh;
  };
  weather_info = writeShellApplication {
    name = "${prefix}-weather_info";
    runtimeInputs = [pkgs.jq pkgs.curl pkgs.coreutils pkgs.gnused];
    text = builtins.readFile ./weather_info.sh;
    excludeShellChecks = ["SC2027" "SC2236" "SC2004" "SC2046" "SC2184" "SC2086" "SC2010" "SC2006" "SC2012" "SC2219" "SC2207" "SC2002"];
  };
  quotes = writeShellApplication {
    name = "${prefix}-quotes";
    text = builtins.readFile ./quotes.sh;
  };
  sys_info = writeShellApplication {
    name = "${prefix}-sys_info";
    text = builtins.readFile ./sys_info.sh;
    excludeShellChecks = ["SC2004" "SC2046" "SC2184" "SC2086" "SC2010" "SC2006" "SC2012" "SC2219" "SC2207" "SC2002"];
  };
  system = writeShellApplication {
    name = "${prefix}-system";
    text = builtins.readFile ./system.sh;
  };
in
  symlinkJoin {
    name = "eww-scripts";
    paths = [music_info weather_info quotes sys_info system];
    meta.mainPrograms = "";
  }
