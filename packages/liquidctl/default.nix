{
  lib,
  pkgs,
}:
pkgs.liquidctl.overrideAttrs (old: {
  src = pkgs.fetchFromGitHub {
    owner = old.pname;
    repo = old.pname;
    rev = "fb697e05c00a9ed8818d88a25d6202f46782d811";
    hash = "sha256-UhjzrprvA1l8nq0On09LU0ZWVRZQ3n5xykyzR5H8o+o=";
  };
  patches = [];
})
