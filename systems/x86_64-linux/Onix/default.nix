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
  ];
  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    timeout = lib.mkForce 5;
  };
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
    pulseaudioFull
    google-chrome
    xivlauncher
    obsidian
    (warp-terminal.overrideAttrs (old: rec {
      version = "0.2024.03.12.08.02.stable_01";
      src = pkgs.fetchurl {
        url = "https://releases.warp.dev/stable/v${version}/warp-terminal-v${version}-1-x86_64.pkg.tar.zst";
        sha256 = "sha256-9reFBIu32TzxE46c3PBVzkZYaMV4HVDASvTAVQltYN0=";
      };
    }))
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
    steam-hardware.enable = true;
    enableRedistributableFirmware = true;
  };
  networking = {
    useDHCP = false;
    interfaces.wlan0.useDHCP = true;
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
      enableHyprland = true;
    };
  };

  virtualisation.docker.enable = true;

  users.users.tod = {
    name = "tod";
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "docker" "adbusers" "networkmanager" "input" "uinput" "dialout"];
    shell = pkgs.fish;
    password = "onix";
  };
  programs = {
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
    openssh.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
  };
  system.stateVersion = "24.05";
}
