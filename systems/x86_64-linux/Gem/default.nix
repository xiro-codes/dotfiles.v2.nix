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
    (import ./disk-configuration.nix {device = "/dev/sda";})
  ];
  local = {
    settings.enable = true;
    desktops = {
      enable = false;
      useEnv = true;
      enableNiri = true;
    };
    boot.efi.bootloader = "none";
  };
  environment.systemPackages = with pkgs; [
  ];
  networking = {
    useDHCP = lib.mkForce true;
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
  users.users.tod = {
    name = "tod";
    isNormalUser = true;
    extraGroups = ["wheel" "audio" "docker" "networkmanager" "input" "uinput" "dialout"];
    shell = pkgs.fish;
    password = "jade";
  };
  programs = {
    fish.enable = true;
    git.enable = true;
  };
  services = {
    openssh.enable = true;
  };
  formatConfigs.install-iso = {
    config,
    modulesPath,
    ...
  }: {
  };
  system.stateVersion = "24.05";
}
