{lib, ...}: let
  inherit (lib) foldl head tail;
in {
  reduce = f: list: (foldl f (head list) (tail list));
}
