{
  lib,
  pkgs,
  libpcap,
  fetchurl,
  flex,
  bison,
  ...
}:
libpcap.overrideAttrs (old: rec {
  postInstall = ''
    ln $out/lib/libpcap.so $out/lib/libpcap.so.0.8
  '';
})
