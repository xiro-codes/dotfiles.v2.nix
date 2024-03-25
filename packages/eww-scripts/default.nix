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
	quotes = writeShellApplication {
			name = "quotes";
			text = builtins.readFile ./quotes.sh;
		};
	sys_info = writeShellApplication {
			name = "sys_info";
			text = builtins.readFile ./sys_info.sh;
		};
	system = writeShellApplication {
			name = "system";
			text = builtins.readFile ./system.sh;
		};
in
  symlinkJoin {
    name = "eww-scripts";
    paths = [music_info weather_info quotes sys_info system];
    meta.mainPrograms = "";
  }
