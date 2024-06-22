{
  lib,
  inputs,
  pkgs,
  gtk4,
  pkg-config,
  rustPlatform,
  fetchFromGitHub,
  makeDesktopItem,
  ...
}:
inputs.hdhomerun-client.packages.${pkgs.system}.default.overrideAttrs (old: {
  desktopItem = makeDesktopItem {
    name = "hdhomerun";
    exec = "hdhomerun-client";
    desktopName = "HdHomerun";
  };
})
