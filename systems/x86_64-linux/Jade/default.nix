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
  ];
  local = {
    settings.enable = true;
    desktops = {
      enable = true;
      enableNiri = true;
    };
    anime-hub.enable = true;
  };
  environment.systemPackages = with pkgs; [
  ];
  networking = {
    useDHCP = true;
    firewall.enable = true;
  };
  virtualisation.docker.enable = true;
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
  system.stateVersion = "24.05";
}
