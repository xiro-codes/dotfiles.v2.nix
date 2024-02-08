{...}: {
  mkNativeGame = {pkgs, ...}: {
    pname,
    bname ? pname,
    path,
    sha256,
    src,
    fixup ? "",
    meta ? {},
  }: let
    inherit (pkgs) stdenvNoCC requireFile zip unzip makeWrapper steam-run curl;
  in
    stdenvNoCC.mkDerivation {};
}
