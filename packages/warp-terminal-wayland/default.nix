{
  lib,
  inputs,
  pkgs,
  stdenv,
  ...
}:
pkgs.warp-terminal.overrideAttrs (old: rec {
  pname = "warp-terminal-wayland";
  version = "0.2024.03.19.08.01.stable_01";
  src = pkgs.fetchurl {
    url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
    sha256 = "sha256-efnYh48xcLneeotH9iSY0xQRgMXI/erM6F2fIH38yjY=";
  };
  nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.makeWrapper stdenv];
  buildInputs = old.buildInputs ++ [pkgs.wayland pkgs.wayland-protocols];
  postInstall = ''
    makeWrapper $out/bin/warp-terminal $out/bin/warp-terminal-wayland --set WARP_ENABLE_WAYLAND 1 \
    	--prefix LD_LIBRARY_PATH : ${pkgs.wayland}/lib
    sed -i $out/share/applications/dev.warp.Warp.desktop -e "s@warp-terminal@warp-terminal-wayland@g"
  '';
  meta = with lib;
    old.meta
    // {
      mainProgram = "warp-terminal-wayland";
    };
})
