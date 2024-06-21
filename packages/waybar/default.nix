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
    rev = "9332697ec1f7e66892deea7a2b56f2ab8a48ac28";
    sha256 = "sha256-MaWUtPQOg7SmSbai+vf8RcFTv3HJmzeQhOUzueWWe/E=";
  };
})
