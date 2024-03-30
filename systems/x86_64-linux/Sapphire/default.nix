{
  system,
  lib,
  host,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (inputs.self.packages.${pkgs.system}) warp-terminal-wayland xivlauncher;
in {
  imports = [
    ./hardware-configuration.nix
    (import ./disk-configuration.nix {device = "/dev/nvme0n1";})
    (import ./hdd-configuration.nix {})
    (import ./ssd-configuration.nix {})
  ];

  environment.systemPackages =
    (with pkgs; [
      xdg-user-dirs
      pulseaudioFull
      obsidian
      discord
      neovide
      helvum
      comma
      via
      google-chrome
      nvtop-amd
      lunatask
    ])
    ++ [warp-terminal-wayland xivlauncher];

  environment.variables = {
    FLAKE = "/etc/nixos";
  };
  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {Experimental = true;};
      };
    };
    opengl.enable = true;
    keyboard.qmk.enable = true;
    pulseaudio.enable = lib.mkForce false;
    enableRedistributableFirmware = true;
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
  local = {
    settings.enable = true;
    desktops = {
      enable = true;
      useEnv = true;
      enableHyprland = true;
      enableNiri = true;
    };

    boot = {
      timeout = 5;
      efi.bootloader = "systemd-boot";
    };
    backups = {
      targets = [
        {
          name = "dotfiles";
          source = "/mnt/hdd/dotfiles.nix";
          dest = "/mnt/hdd/backups/dotfiles.nix";
        }
      ];
    };
  };

  virtualisation.docker.enable = true;

  users.users.tod = {
    name = "tod";
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "docker" "adbusers" "networkmanager" "input" "uinput" "dialout"];
    shell = pkgs.fish;
    password = "sapphire";
  };
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk xdg-desktop-portal-kde];

  programs = {
    coolercontrol.enable = true;
    fish.enable = true;
    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    git.enable = true;
    kdeconnect.enable = true;
    adb.enable = true;
  };

  nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 5d --keep 10";
  };
  services = {
    blueman.enable = true;
    komga = {
      enable = false;
      port = 8090;
      openFirewall = true;
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    openssh.enable = true;
    openssh.settings.PermitRootLogin = "yes";
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
  };

  systemd.timers."backup" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5s";
      Unit = "backup.service";
    };
  };
  systemd.services."backup" = {
    script = ''
      ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot /mnt/ssd/workspaces /mnt/ssd/backups/workspaces.`date +%Y-%m-%d@%H-%M-%S`
      ${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot /mnt/hdd/documents /mnt/hdd/backups/documents.`date +%Y-%m-%d@%H-%M-%S`
    '';
    serviceConfig = {
      User = "root";
      Type = "oneshot";
    };
  };
  system.stateVersion = "24.05";
}
