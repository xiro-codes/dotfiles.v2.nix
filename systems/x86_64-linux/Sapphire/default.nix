{
  system,
  lib,
  host,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (inputs.self.packages.${pkgs.system}) warp-terminal-wayland xivlauncher liquidctl;
  inherit (lib) getExe;
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
      nvtop-amd
      firefox
    ])
    ++ [warp-terminal-wayland xivlauncher liquidctl];

  environment.variables = {
    FLAKE = "/etc/nixos";
  };
  hardware = {
    bluetooth = {
      enable = true;
      package = pkgs.bluez-experimental;
      input.General = {ClassicBondedOnly = false;};
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
        {
          name = "documents";
          source = "/mnt/hdd/documents";
          dest = "/mnt/hdd/backups/documents";
        }
        {
          name = "workspaces";
          source = "/mnt/ssd/workspaces";
          dest = "/mnt/ssd/backups/workspaces";
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
    tailscale.enable = true;
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

  systemd.timers."aio-init" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnBootSec = "5s";
      Unit = "aio-init.service";
    };
  };

  systemd.services."aio-init" = {
    script = ''
      ${getExe liquidctl} initialize all
      ${getExe liquidctl} set fan speed 30 30 40 50 60 70
      ${getExe liquidctl} set pump speed 30 20 40 50
    '';
    serviceConfig = {
      User = "root";
      Type = "oneshot";
    };
  };
  system.stateVersion = "24.05";
}
