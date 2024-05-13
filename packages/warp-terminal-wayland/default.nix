{
  lib,
  inputs,
  pkgs,
  stdenv,
  ...
}:
pkgs.warp-terminal.overrideAttrs (old: rec {
  pname = "warp-terminal";
  version = "0.2024.04.30.08.02.stable_02";
  src = pkgs.fetchurl {
    url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
    sha256 = "sha256-lC/xGxpUpLq3ZsI41RNcuxUEuVXPJzmBarE/pOFJuzE=";
  };
  nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.makeWrapper];
  postInstall = ''
    wrapProgram $out/bin/warp-terminal --set WARP_ENABLE_WAYLAND 1 \
    	--prefix LD_LIBRARY_PATH : ${pkgs.wayland}/lib
  '';
})
