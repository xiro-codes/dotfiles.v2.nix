{
  pkgs,
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.local;
  self = cfg.boot.bios;
  inherit (lib) mkOption mkIf mkMerge types mkDefault;
in {
  options.local.boot.bios = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };
  config = mkIf (self.enable) {
    boot.loader = {
      systemd-boot.enable = false;
      grub.useOSProber = true;
			grub.devices = [ "/dev/sda" ];
    };
    assertions = [
      {
        assertion = !(cfg.boot.efi.bootloader == "");
        message = "BIO's || UEFI";
      }
    ];
  };
}
