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
    (import ./disk-configuration.nix {device = "/dev/nvme0n1";})
    (import ./hdd-configuration.nix {})
    (import ./ssd-configuration.nix {})
  ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = lib.mkForce 5;
  };
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
    pulseaudioFull
   ( xivlauncher.overrideAttrs (old: {
		 version = "1.0.8";
		src = pkgs.fetchFromGitHub {
				owner = "goatcorp";
				repo = "XIVLauncher.core";
				rev = "1.0.8";
				hash = "sha256-x4W5L4k+u0MYKDWJu82QcXARW0zjmqqwGiueR1IevMk=";
				fetchSubmodules = true;
			};
		}))
    obsidian
		discord
		google-chrome
		steam-tui
		(inputs.self.packages.${pkgs.system}.warp-terminal-wayland)
  ];

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
      enable = false;
      wifi.backend = "iwd";
    };
    wireless = {
      enable = false;
      iwd.enable = false;
    };
  };
  local = {
    settings.enable = true;
    desktops = {
      enable = true;
      enableHyprland = true;
			enablePlasma6 = false;
			enableNiri = false;
      useEnv = true;
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
		chromium = {
			enable = true;
			enablePlasmaBrowserIntegration = true;
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
		blueman.enable=true;
    komga = {
      enable = true;
      port = 8090;
      openFirewall = true;
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    plex = {
      enable = true;
      openFirewall = true;
    };
    openssh.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
  };
	systemd.timers."backup" = {
		wantedBy = [ "timers.target" ];
			timerConfig = {
				OnBootSec = "5s";
				Unit = "backup.service";
			};
	};
	systemd.timers."download" = {
		wantedBy = [ "timers.target" ];
			timerConfig = {
				OnUnitActiveSec = "30m";
				OnBootSec = "5s";
				Unit = "download.service";
			};
	};
	systemd.services."backup" = {
    script = ''
				${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot /mnt/hdd/dotfiles.nix /mnt/hdd/backups/dotfiles.nix.`date +%Y-%m-%d@%H-%M-%S` 
				${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot /mnt/ssd/workspaces /mnt/ssd/backups/workspaces.`date +%Y-%m-%d@%H-%M-%S` 
				${pkgs.btrfs-progs}/bin/btrfs subvolume snapshot /mnt/hdd/documents /mnt/hdd/backups/documents.`date +%Y-%m-%d@%H-%M-%S` 
      '';
    serviceConfig = {
			User = "root";
			Type = "oneshot";
    };
  };
	systemd.services."download" = {
    script = ''
				PATH=${lib.makeBinPath [ pkgs.ffmpeg ]}
				${pkgs.reddsaver}/bin/reddsaver -e /home/tod/reddsaver.env -d /home/tod/reddit -H 
      '';
    serviceConfig = {
			User = "root";
			Type = "oneshot";
    };
  };

  system.stateVersion = "24.05";
}
