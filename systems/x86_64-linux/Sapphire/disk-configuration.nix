{device ? "/dev/nvme0n1", ...}: {
  disko.devices = {
    disk = {
      main = {
        inherit device;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "btrfs";
                mountpoint = "/mnt/root";
                subvolumes = {
                  "/rootfs" = {mountpoint = "/";};
                  "/home" = {mountpoint = "/home";};
                  "/nix" = {mountpoint = "/nix";};
                  #"/ffxiv" = {mountpoint = "/home/tod/.xlcore";};
                };
              };
            };
          };
        };
      };
    };
  };
}
