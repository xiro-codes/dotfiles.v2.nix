{
  pkgs,
  inputs,
  lib,
  makeDesktopItem,
  ...
}: let
  desktopSession = ''
    [Desktop Entry]
    Name=Niri
    Exec=niri
  '';
in
  inputs.niri.packages.x86_64-linux.default.overrideAttrs (old: {
    postBuild = ''
      mkdir -p $out/share/wayland-sessions
      echo "${desktopSession}" > $out/share/wayland-sessions/niri.desktop
    '';
  })
