{
  device0 ? "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S59WNZFN403484T",
  device1 ? "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_250GB_S59WNZFN901704H",
  ...
}: {
  disko.devices = {
    lvm_vg = {
      ssd-pool = {
        type = "lvm_vg";
        lvs = {
          vol = {
            size = "100%FREE";
            content = {
              type = "btrfs";
              mountpoint = "/mnt/ssd";
              subvolumes = {
                "/workspaces" = {
                  mountpoint = "/home/tod/Workspaces";
                };
                "/games" = {
                  mountpoint = "/home/tod/Games";
                };
              };
            };
          };
        };
      };
    };
    disk = {
      ssd0 = {
        device = device0;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "ssd-pool";
              };
            };
          };
        };
      };
      ssd1 = {
        device = device1;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            primary = {
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "ssd-pool";
              };
            };
          };
        };
      };
    };
  };
}
