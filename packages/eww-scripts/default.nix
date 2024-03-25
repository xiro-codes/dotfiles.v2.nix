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
in
  symlinkJoin {
    name = "eww-scripts";
    paths = [ music_info ];
    meta.mainPrograms = "";
  }
