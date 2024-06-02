{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
  ];
  home.username = "tod";
  home.homeDirectory = "/home/tod";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
    unzip
    p7zip
    sysstat
    pcmanfm
    vlc
    xarchiver
    feh
    grim
    slurp
    transmission-gtk
    bottom
    duf
    dust
    lazygit
  ];

  fonts.fontconfig.enable = true;

  local = {
    enable = true;

    nixvim.enable = true;

    kitty.enable = true;
    joshuto.enable = true;
    hyprland.enable = false;
    guiFileManager = "${lib.getExe pkgs.pcmanfm}";
    guiTerminal = "${lib.getExe inputs.self.packages.${pkgs.system}.warp-terminal-wayland}";
    theme = "arin";
  };
  programs = {
    home-manager.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      userName = "xiro_codes";
      userEmail = "github@tdavis.dev";
      extraConfig = {
        credential.helper = "store";
        safe.directory = "*";
        core.sshCommand = "ssh -i /home/tod/.ssh/github";
      };
    };
  };
}
