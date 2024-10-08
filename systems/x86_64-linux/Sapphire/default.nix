{
  system,
  lib,
  host,
  pkgs,
  config,
  inputs,
  ...
}: let
  inherit (inputs.self.packages.${pkgs.system}) liquidctl tekkit-classic xivlauncher;
  inherit (lib) getExe;
in {
  imports = [
    ./hardware-configuration.nix
    (import ./disk-configuration.nix {})
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
      nvtopPackages.amd
      firefox
      mangohud
      mpv
    ])
    ++ [
      liquidctl
      inputs.hdhomerun-client.packages.${pkgs.system}.default
    ];
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
      enable = false;
      wifi.backend = "iwd";
    };
    wireless = {
      enable = false;
      iwd.enable = true;
    };
  };

  local = let
    videoDir = "/mnt/hdd/videos";
    backupsDir = "/mnt/hdd/backups";
  in {
    settings.enable = true;
    bluetooth.enable = true;
    #networking.enable = true;
    desktops = {
      enable = true;
      useEnv = true;
      enableHyprland = true;
    };
    boot = {
      timeout = 5;
      efi.bootloader = "systemd-boot";
    };
    youtube-dl = {
      freq = "30m";
      targets = [
        {
          name = "Dashadrywet";
          channel = "https://www.youtube.com/@dashadrywet";
          dest = "${videoDir}/youtube/Dshadrywet";
        }
        {
          name = "CookieSwirl";
          channel = "https://www.youtube.com/@TheCookieSwirl";
          dest = "${videoDir}/youtube/CookieSwirl";
        }
        {
          name = "SomeOrdinaryGamers";
          channel = "https://www.youtube.com/@SomeOrdinaryGamers";
          dest = "${videoDir}/youtube/SomeOrdinaryGamers";
        }
        {
          name = "BellularNews";
          channel = "https://www.youtube.com/@BellularNews";
          dest = "${videoDir}/youtube/BellularNews";
        }
        {
          name = "Avarisi";
          channel = "https://www.youtube.com/@avarisi";
          dest = "${videoDir}/youtube/Avarisi";
        }
        {
          name = "UpperEchelon";
          channel = "https://www.youtube.com/@UpperEchelon";
          dest = "${videoDir}/youtube/UpperEchelon";
        }
        {
          name = "Pint";
          channel = "https://www.youtube.com/@PintFrumpyrat";
          dest = "${videoDir}/youtube/Pint";
        }
        {
          name = "CiderSpider";
          channel = "https://www.youtube.com/@CiderSpider";
          dest = "${videoDir}/youtube/CiderSpider";
        }
        {
          name = "CriticalReacts";
          channel = "https://www.youtube.com/@CriticalReacts";
          dest = "${videoDir}/youtube/CriticalReacts";
        }
        {
          name = "AtriocClips";
          channel = "https://www.youtube.com/@AtriocClips";
          dest = "${videoDir}/youtube/AtriocClips";
        }
      ];
    };
    backups = {
      targets = [
      ];
    };
  };

  virtualisation = {
    docker.enable = true;
    virtualbox.host.enable = true;
  };

  users = {
    extraGroups.vboxusers.members = ["tod"];
    users.tod = {
      name = "tod";
      isNormalUser = true;
      extraGroups = ["wheel" "audio" "docker" "adbusers" "networkmanager" "input" "uinput" "dialout"];
      shell = pkgs.fish;
      password = "sapphire";
    };
  };

  programs = {
    #coolercontrol.enable = true;
    fish.enable = true;
    gamescope.enable = false;
    steam = {
      enable = true;
      localNetworkGameTransfers.openFirewall = true;
    };
    git.enable = true;
    #nh = {
    #  enable = true;
    #  clean.enable = true;
    #  clean.extraArgs = "--keep-since 5d --keep 10";
    #};
					anime-game-launcher.enable = true; # Adds launcher and /etc/hosts rules
          anime-games-launcher.enable = true;
          anime-borb-launcher.enable = true;
          honkers-railway-launcher.enable = true;
          honkers-launcher.enable = true;
          wavey-launcher.enable = true;
          sleepy-launcher.enable = true;
  };
  services = {
    flatpak.enable = true;
    printing.enable = true;
    tailscale.enable = true;
    blueman.enable = true;
    komga = {
      enable = false;
      port = 8090;
      openFirewall = true;
    };
    jellyfin = {
      enable = false;
      openFirewall = true;
      user = "tod";
    };
    ollama = {
      enable = false;
      sandbox = false;
      acceleration = "rocm";
      environmentVariables = {
        OLLAMA_ORIGINS = "*";
      };
    };
    openssh.enable = true;
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
