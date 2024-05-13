{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local;
  inherit (lib) mkOption mkIf types;
  inherit (types) bool;
in {
  options.local.settings.enable = mkOption {
    type = bool;
    default = false;
  };
  config = mkIf cfg.settings.enable {
    nix = {
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-users = ["tod"];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      extraOptions = ''
        extra-experimental-features = nix-command
        extra-experimental-features = flakes
        extra-experimental-features = auto-allocate-uids
        keep-outputs = true
        keep-derivations = true
      '';
      gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = ["weekly"];
      };
    };

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "America/Chicago";
    time.hardwareClockInLocalTime = true;
  };
}
