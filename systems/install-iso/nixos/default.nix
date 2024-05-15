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
    ++ [warp-terminal-wayland];

  environment.variables = {
    FLAKE = "/etc/nixos";
  };
  hardware = {
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
    bluetooth.enable = true;
    #networking.enable = true;
    desktops = {
      enable = true;
      useEnv = true;
      enableHyprland = true;
      enableNiri = false;
    };

    boot = {
      timeout = 5;
      efi.bootloader = "systemd-boot";
    };
  };

  virtualisation.docker.enable = true;

  users.users.nixos = {
    name = "nixos";
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "docker" "adbusers" "networkmanager" "input" "uinput" "dialout"];
    shell = pkgs.fish;
    password = "nixos";
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
    minecraft-server = {
      enable = true;
      eula = true;
      openFirewall = true;
      dataDir = "/mnt/hdd/minecraft";
    };
    jellyfin = {
      enable = true;
      openFirewall = true;
    };
    flatpak.enable = true;
    openssh.enable = true;
    openssh.settings.PermitRootLogin = "yes";
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = false;
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
