{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.self.packages.${pkgs.system}) hyprland-scripts;
  libbluray = pkgs.libbluray.override {
    withAACS = true;
    withBDplus = true;
  };
  vlc' = pkgs.vlc.override {inherit libbluray;};
in {
  imports = [
  ];
  home.username = "tod";
  home.homeDirectory = "/home/tod";

  home.stateVersion = "23.05"; # Please read the comment before changing.
  home.packages = with pkgs; [
    nerdfonts
    unzip
    p7zip
    sysstat
    pcmanfm
    vlc'
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

    eww.enable = true;
    kitty.enable = true;

    joshuto.enable = true;

    guiFileManager = "${lib.getExe pkgs.pcmanfm}";
    guiTerminal = "${lib.getExe inputs.self.packages.${pkgs.system}.warp-terminal-wayland}";

    hyprland.monitors = [
      {
        name = "DP-1";
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
    waybar.theme = "arin";
    theme = "arin";
  };
  home.file = {
    ".wallpaper".source = ./arin.png;
  };
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.vanilla-dmz;
      name = "Vanilla-DMZ";
      size = 16;
    };
    iconTheme = {
      package = pkgs.gruvbox-dark-icons-gtk;
      name = "oomox-gruvbox-dark";
    };
  };
  qt = {
    enable = true;
    platformTheme = "gtk";
  };
  systemd.user.services = {
    eww = {
      Unit = {
        Description = "Launch Eww";
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        ExecStart = "${hyprland-scripts}/bin/wm-launch";
      };
    };
    monitors-hook = {
      Unit = {
        Description = "Relaunh hud on monitor change";
      };
      Install = {
        WantedBy = ["default.target"];
      };
      Service = {
        ExecStart = "${hyprland-scripts}/bin/wm-monitors-hook";
        Restart = "always";
      };
    };
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
