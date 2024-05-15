{
  pkgs,
  lib,
  input,
  stdenv,
  fetchFromGitHub,
  ninja,
  cmake,
  curl,
  pkg-config,
  SDL2,
  autoPatchelfHook,
  lz4,
  p7zip,
  makeWrapper,
  ...
}:
stdenv.mkDerivation {
  pname = "Lampray";
  version = "0.1.0";
  src = fetchFromGitHub {
    owner = "CHollingworth";
    repo = "lampray";
    rev = "c90e0384a9db2333c64794bc56261d2c91915579";
    sha256 = "sha256-ygV9IWsNsGO1QJ3cc7rl6hSvD3pp6UM1nZEQuai1q8M=";
  };
  buildInputs = [ninja cmake curl pkg-config SDL2 autoPatchelfHook lz4 makeWrapper];
  installPhase = ''
       mkdir -p $out/bin
       cp Lampray $out/bin
    wrapProgram $out/bin/Lampray --prefix LIBRARY_PATH : ${lib.makeLibraryPath [p7zip.lib]}
  '';
}
