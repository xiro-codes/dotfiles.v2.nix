{
  device0 ? "/dev/disk/by-id/ata-TOSHIBA_DT01ACA100_69C5R9EMS",
  device1 ? "/dev/disk/by-id/ata-WDC_WD1003FZEX-00K3CA0_WD-WCC6Y4HSL50L",
  device2 ? "/dev/disk/by-id/usb-Seagate_Backup+_Hub_BK_NA9RR3RS-0:0",
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
                  mountpoint = "/home/tod/Desktop";
                };
                "/documents" = {
                  mountOptions = ["compress=zstd"];
                  mountpoint = "/home/tod/Documents";
                };
                "/downloads" = {
                  mountOptions = ["compress=zstd"];
                  mountpoint = "/home/tod/Downloads";
                };
                "/minecraft" = {
                };
                "/dotfiles.nix" = {
                  mountpoint = "/etc/nixos";
                };
                "/ssh" = {
                  mountpoint = "/home/tod/.ssh";
                };
                "/videos" = {
                  mountOptions = ["compress=zstd"];
                  mountpoint = "/home/tod/Videos";
                };
                "/music" = {
                  mountOptions = ["compress=zstd"];
                  mountpoint = "/home/tod/Music";
                };
              };
            };
          };
        };
      };
    };
    disk = {
      hdd2 = {
        device = device2;
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
