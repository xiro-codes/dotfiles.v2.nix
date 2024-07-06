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
  ];

  environment.variables = {
    FLAKE = "/etc/nixos";
  };
  hardware = {
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
    boot = {
      timeout = 5;
      efi.bootloader = "systemd-boot";
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
    git.enable = true;
  };

  services = {
    openssh.enable = true;
    jellyfin = {
      enable = true;
      openFirewall = true;
      user = "tod";
      group = "users";
    };
  };
  fileSystems."/mnt/storage" = {
    device = "/dev/disk/by-id/ata-WDC_WD10EZEX-22MFCA0_WD-WCC6Y2AV1NZC-part1";
  };
	fileSystems."/mnt/media" = {
		device = "/dev/disk/by-id/ata-ST8000DM004-2U9188_ZR12S72H-part1";
	};
  system.stateVersion = "24.05";
}
