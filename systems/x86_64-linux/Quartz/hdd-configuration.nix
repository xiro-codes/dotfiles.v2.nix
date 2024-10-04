{
  device0 ? "/dev/disk/by-id/ata-TOSHIBA_DT01ACA100_69C5R9EMS",
  device1 ? "/dev/disk/by-id/ata-WDC_WD1003FZEX-00K3CA0_WD-WCC6Y4HSL50L",
  ...
}: {
  disko.devices = {
    lvm_vg = {
      hdd-pool = {
        type = "lvm_vg";
        lvs = {
          vol = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              mountpoint = "/mnt/hdd";
              subvolumes = {
                "/desktop" = {
                };
                "/documents" = {
                  mountOptions = ["compress=zstd"];
                };
                "/downloads" = {
                  mountOptions = ["compress=zstd"];
                };
                "/pictures" = {
                  mountOptions = ["compress=zstd"];
                };
                "/minecraft" = {
                };
                "/dotfiles.nix" = {
                };
                "/ssh" = {
                };
                "/videos" = {
                };
                "/music" = {
                  mountOptions = ["compress=zstd"];
                };
                "/ffxiv" = {
                };
              };
            };
          };
        };
      };
    };
    disk = {
      hdd1 = {
        device = device1;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "hdd-pool";
              };
            };
          };
        };
      };
      hdd0 = {
        device = device0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "hdd-pool";
              };
            };
          };
        };
      };
    };
  };
}
