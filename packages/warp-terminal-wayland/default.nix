{
  lib,
  inputs,
  pkgs,
  stdenv,
  ...
}:
pkgs.warp-terminal.overrideAttrs (old: rec {
  pname = "warp-terminal";
  version = "0.2024.05.14.08.01.stable_04";
  src = pkgs.fetchurl {
    url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
    sha256 = "sha256-16ZMzvdkAAf9xSiL7TCaiJwEMd+jbOYIL/xiF2Todbw=";
  };
  nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.makeWrapper];
  postInstall = ''
    wrapProgram $out/bin/warp-terminal --set WARP_ENABLE_WAYLAND 1 \
    	--prefix LD_LIBRARY_PATH : ${pkgs.wayland}/lib
  '';
})
