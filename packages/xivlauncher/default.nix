{ lib, inputs, pkgs, xivlauncher, makeDesktopItem, ... }: xivlauncher.overrideAttrs (old: rec {
  version = "1.0.8";
  src = pkgs.fetchFromGitHub {
    owner = "goatcorp";
    repo = "XIVLauncher.core";
    rev = version;
    hash = "sha256-x4W5L4k+u0MYKDWJu82QcXARW0zjmqqwGiueR1IevMk=";
    fetchSubmodules = true;
  };
  postFixup = old.postFixup + ''
    				makeWrapper $out/bin/.XIVLauncher.Core-wrapped $out/bin/XIVLauncher.Core.Insecure --set XL_SECRET_PROVIDER FILE
    			'';
  desktopItems = [
    (makeDesktopItem {
      name = "xivlauncher";
      exec = "XIVLauncher.Core.Insecure";
      icon = "xivlauncher";
      desktopName = "XIVLauncher";
      comment = old.meta.description;
      categories = [ "Game" ];
      startupWMClass = "XIVLauncher.Core";
    })
  ];
  meta = old.meta // { mainProgram = "XIVLauncher.Core.Insecure"; };
})

