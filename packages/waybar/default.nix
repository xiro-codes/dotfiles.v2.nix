{
  lib,
  pkgs,
  inputs,
  waybar,
  fetchFromGitHub,
  ...
}:
waybar.overrideDerivation (old: {
  version = "10.0.0-git";
  src = fetchFromGitHub {
    owner = "Alexays";
    repo = "waybar";
    rev = "42dc9cb85f27e3db02da83cd13624cfc5a7191d3";
    sha256 = "sha256-R3yPS5ktvzhUI+TeHTDkbKgiA8SDvozu33azFUeMVoo=";
  };
})
