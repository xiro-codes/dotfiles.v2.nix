{
  lib,
  inputs,
  pkgs,
  stdenv,
  ...
}:
pkgs.warp-terminal.overrideAttrs (old: rec {
  pname = "warp-terminal";
  version = "0.2024.04.09.08.01.stable_01";
  src = pkgs.fetchurl {
    url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
    sha256 = "sha256-YkQN4e6QeO8Kltf45Pg9Kcei1u/FsBGHqg4ttayh/0g=";
  };
  nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.makeWrapper];
  postInstall = ''
    wrapProgram $out/bin/warp-terminal --set WARP_ENABLE_WAYLAND 1 \
    	--prefix LD_LIBRARY_PATH : ${pkgs.wayland}/lib
  '';
})
