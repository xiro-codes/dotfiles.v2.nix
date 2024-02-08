{
  lib,
  inputs,
  pkgs,
  stdenv,
  openssl,
  pkg-config,
  ...
}:
pkgs.rustPlatform.buildRustPackage {
  pname = "hdhomerun_status";
  version = "0.1.0";
  src = pkgs.fetchFromGitHub {
    owner = "xiro-codes";
    repo = "hdhomerun_status";
    rev = "08d14c6defb7509e2e5a1df72b2b6b11da590e36";
    sha256 = "sha256-Wzx30TC+CzESYumnEMKV9ZD7CNoYrjct8w1Ved7OAIM=";
  };
  nativeBuildInputs = [
    pkg-config
  ];
  buildInputs = [openssl];
  cargoSha256 = "sha256-mssUrUX2EIv06GdfgZW2U345osqmtdkVgh15BA2xdFM=";
}
