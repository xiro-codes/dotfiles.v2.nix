{
  lib,
  pkgs,
  inputs,
  rustPlatform,
  fetchFromGitHub,
  ...
}:
rustPlatform.buildRustPackage {
  pname = "loungy";
  version = "0.1.2";
  src = fetchFromGitHub {
    owner = "MatthiasGrandl";
    repo = "loungy";
    rev = "v0.1.2";
    sha256 = "sha256-AlZsL251jQ+iyk9CSqFcjjM64KEKeQ6SfoNgXQHMtdA=";
  };
  nativeBuildInputs = [pkgs.pkg-config];
  buildInputs = [pkgs.openssl];
  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "blade-graphics-0.3.0" = "sha256-0TmunFnq9MBxm4TrAkI0PxB58qJEf7oWLWhHq5cVsQ8=";
      "collections-0.1.0" = "sha256-SLKVUTqLmAl3jhpeoYIoWsAWu5NkoIsgJUAr3DDm/CA=";
      "font-kit-0.11.0" = "sha256-+4zMzjFyMS60HfLMEXGfXqKn6P+pOngLA45udV09DM8=";
      "taffy-0.3.11" = "sha256-0hXOEj6IjSW8e1t+rvxBFX6V9XRum3QO2Des1XlHJEw=";
    };
  };
}
