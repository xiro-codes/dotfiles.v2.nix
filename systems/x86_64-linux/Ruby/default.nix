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
  local = {
    settings.enable = true;
    desktop = {
      enable = true;
      useEnv = true;
      enableHyprland = true;
      enableGreeter = false;
    };
  };
  environment.systemPackages = with pkgs; [
    xdg-user-dirs
    pulseaudioFull
    inputs.self.packages.${system}.niri
  ];
  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
    keyboard.qmk.enable = true;
    pulseaudio.enable = lib.mkForce false;
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
  virtualisation.docker.enable = true;
  users.users.tod = {
    name = "tod";
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "docker" "networkmanager" "input" "uinput" "dialout"];
    shell = pkgs.fish;
    password = "ruby";
  };
  programs = {
    fish.enable = true;
    steam.enable = true;
    git.enable = true;
    kdeconnect.enable = true;
  };
  services = {
    tailscale.enable = false;

    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;
    };

    openssh.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    xserver.displayManager.sessionPackages = [config.programs.hyprland.finalPackage];
  };
  jovian = {
    decky-loader.enable = true;
    devices.steamdeck.enable = true;

    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "niri";
      user = "tod";
    };
  };
  system.stateVersion = "24.05";
}
