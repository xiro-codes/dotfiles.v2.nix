{lib, ...}: let
  inherit (lib) foldl head tail;
in {
  reduce = f: list: (foldl f (head list) (tail list));
  mapMonitors = monitors:
    map (m: let
      resolution = "${toString m.width}x${toString m.height}@${toString m.rate}";
      position = "${toString m.x}x${toString m.y}";
      transform = "transform,${toString m.transform}";
    in "${m.name},${
      if m.enabled
      then "${resolution},${position},${toString m.scale},${transform}"
      else "disable"
    }")
    monitors;
}
