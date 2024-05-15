{
  lib,
  pkgs,
  inputs,
  waybar,
  fetchFromGitHub,
  ...
}:
waybar.overrideAttrs (old: {
  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "waybar";
    rev = "42dc9cb85f27e3db02da83cd13624cfc5a7191d3";
    sha256 = "";
  };
})
