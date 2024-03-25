{
  lib,
  pkgs,
  symlinkJoin,
  writeShellApplication,
  writeShellScriptBin,
  ...
}: let
  inherit (lib) getExe;
  music_info = writeShellApplication {
    name = "music_info";
    text = builtins.readFile ./music_info.sh;
  };
	weather_info = writeShellApplication {
			name = "weather_info";
			text = builtins.readFile ./weather_info.sh;
		};
in
  symlinkJoin {
    name = "eww-scripts";
    paths = [music_info weather_info];
    meta.mainPrograms = "";
  }
