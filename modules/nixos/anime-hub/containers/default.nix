{lib, ...}:
with lib;
with builtins; {
  imports = [./shoko.nix ./komga.nix ./pihole.nix ./jellyfin.nix ./lanraragi.nix];
  options.local.anime-hub.containers = {
    mediaFolder = mkOption {type = types.str;};
  };
}
