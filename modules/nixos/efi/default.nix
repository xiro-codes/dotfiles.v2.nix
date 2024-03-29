{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local;
  self = cfg.boot.efi;
  inherit (lib) mkOption mkIf mkMerge types mkDefault;
in {
  options.local.boot.efi = {
    bootloader = mkOption {
      type = types.enum ["none" "grub" "systemd-boot"];
      default = "none";
    };
  };
  config = mkMerge [
    (mkIf (self.bootloader == "systemd-boot") {
      boot.loader = {
        systemd-boot = {
          enable = true;
          editor = mkDefault false;
        };
        efi.canTouchEfiVariables = true;
      };
    })
    (mkIf (self.bootloader == "grub") {
      boot.loader = {
        systemd-boot.enable = false;
        grub = {
          enable = true;
          useOSProber = true;
          efiSupport = true;
          device = "nodev";
        };
      };
    })
    {
      assertions = [
        {
          assertion = !cfg.boot.bios.enable;
          message = "BIO's || UEFI";
        }
      ];
    }
  ];
}
