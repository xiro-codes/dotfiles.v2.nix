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
      package = pkgs.nixVersions.latest;
      settings = {
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
          "https://cosmic.cachix.org/"
          "https://ezkea.cachix.org"
        ];
        trusted-users = ["tod"];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE="
          "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
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
