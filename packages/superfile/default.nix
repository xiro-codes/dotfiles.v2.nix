{
  pkgs,
  inputs,
  lib,
  buildGoModule,
  fetchFromGitHub,
  exiftool,
  makeWrapper,
  ...
}:
buildGoModule rec {
  name = "superfile";
  buildInputs = [makeWrapper];
  src =
    fetchFromGitHub {
      owner = "xiro-codes";
      repo = "superfile";
      rev = "9235f57dc2e08ac3a3455767d9ac13a9e5bcaf9a";
      sha256 = "sha256-PFIbZQTw5cyjb1tLjACeK+q1LEnwtSpGOHFHNt5eqnY=";
    }
    + "/src";
  vendorHash = "sha256-i4OB9z8GapihAXn5k4pRpdZ5ICF544EUOstqnoO2xKM=";
  postInstall = ''
    wrapProgram "$out/bin/superfile" --prefix PATH : "${exiftool}/bin"
  '';
  meta = with lib; {
    description = "A simple file manager for golang";
    homepage = "https://github.com/MHNightCat/superfile";
  };
}
