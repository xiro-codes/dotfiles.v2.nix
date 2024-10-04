{
  system,
  lib,
  host,
  pkgs,
  config,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    (import ./disk-configuration.nix {})
    (import ./ssd-configuration.nix {})
    (import ./hdd-configuration.nix {})
  ];
  hardware = {
    opengl.enable = true;
    keyboard.qmk.enable = true;
    pulseaudio.enable = lib.mkForce false;
    enableRedistributableFirmware = true;
  };
  local = {
    settings.enable = true;
    bluetooth.enable = true;
    desktops = {
      enable = false;
      useEnv = false;
      enableHyprland = false;
    };
    boot = {
      timeout = 5;
      efi.bootloader = "systemd-boot";
    };
  };
  networking = {
    useDHCP = false;
    firewall.enable = true;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless = {
      enable = false;
      iwd.enable = true;
    };
  };
  users = {
    users.tod = {
      name = "tod";
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "input" "uinput" "dialout"];
      shell = pkgs.fish;
      password = "quartz";
    };
  };
  environment.systemPackages = [
    inputs.zen-browser.packages.${system}.default
    pkgs.nvtopPackages.amd
  ];
  programs = {
    fish.enable = true;
    git.enable = true;
    fuse.userAllowOther = true;
    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    anime-game-launcher.enable = true;
    honkers-launcher.enable = false;
    honkers-railway-launcher.enable = true;
  };
  services = {
    blueman.enable = true;
    openssh.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    desktopManager.cosmic.enable = true;
    displayManager.cosmic-greeter.enable = true;
  };
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';
  fileSystems."/persist".neededForBoot = true;
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos"
      "/var/log"
      "/var/lib/bluetooth"
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
    ];
    files = [
    ];
  };
  fileSystems."/mnt/Videos" = {
    device = "onix.home:/mnt/Media/Videos";
    fsType = "nfs";
  };
  fileSystems."/mnt/Roms" = {
    device = "onix.home:/mnt/Media/Roms";
    fsType = "nfs";
  };
  system.stateVersion = "24.05";
}
