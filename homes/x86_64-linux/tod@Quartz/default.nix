{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.packages.${pkgs.system}) hyprland-scripts vlc fuchsia-cursor;
  inherit (lib) getExe;
in {
  imports = [
  ];
  home.username = "tod";
  home.homeDirectory = "/home/tod";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  home.packages = with pkgs;
    [
      sysstat
      pcmanfm
      xarchiver
      feh
      grim
      slurp
      bottom
      duf
      dust
      lazygit
    ]
    ++ [];
  home.persistence."/persist/home/tod" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      ".ssh"
      ".zen"
      ".config/cosmic"
      ".local/share/cosmic"
      ".local/state/cosmic"
      ".local/state/cosmic-comp"
      ".local/share/direnv"
      ".local/share/zoxide"
      ".local/share/Steam"
    ];
    files = [
    ];
    allowOther = true;
  };
  local = {
    enable = true;
    fonts.enable = true;

    nixvim.enable = true;

    eww.enable = true;
    kitty.enable = true;

    ranger.enable = true;
    guiFileManager = "${lib.getExe pkgs.pcmanfm}";
    guiTerminal = "${lib.getExe' inputs.self.packages.${pkgs.system}.warp-terminal-wayland "warp-terminal"}";

    hyprland = {
      autostart = [
        "steam -silent"
        "${getExe hyprland-scripts}"
        "${getExe pkgs.swaybg} -m fill -i ~/.wallpaper"
      ];
      monitors = [
        {
          name = "DP-1";
          enabled = true;
          scale = 1;
          width = 1920;
          height = 1080;
          rate = 60;
          x = 320;
          y = 1080;
          workspaces = [1 2 3];
        }
        {
          name = "HDMI-A-1";
          scale = 1;
          width = 2560;
          height = 1080;
          rate = 60;
          x = 0;
          y = 0;
          workspaces = [4 5 6];
        }
      ];
    };
    theme = "arin";
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = fuchsia-cursor;
      name = "fuchsia";
      size = 24;
    };
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "oomox-gruvbox-dark";
    };
  };
  qt = {
    enable = true;
    platformTheme.name = "gtk";
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
    obs-studio = {
      enable = true;
      plugins = [
        pkgs.obs-studio-plugins.wlrobs
        pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      ];
    };
  };
}
