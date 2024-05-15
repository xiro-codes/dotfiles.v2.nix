{
  pkgs,
  inputs,
  lib,
  vlc,
}: let
  libbluray = pkgs.libbluray.override {
    withAACS = true;
    withBDplus = true;
  };
in
  vlc.override {inherit libbluray;}
