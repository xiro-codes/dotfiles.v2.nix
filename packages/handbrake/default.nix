{
  pkgs,
  inputs,
  lib,
  handbrake,
}: let
  libbluray = pkgs.libbluray.override {
    withAACS = true;
    withBDplus = true;
  };
in
  handbrake.override {inherit libbluray;}
