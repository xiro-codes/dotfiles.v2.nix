{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkOption mkIf types;
  cfg = config.local;
in {
  imports = [];
  options.local.lf = {
    enable = mkOption {
      type = types.bool;
      default = cfg.enable;
    };
  };
  config = mkIf (cfg.lf.enable) {
    xdg.configFile."lf/icons".source = ./icons;
    programs.lf = {
      enable = true;
      commands = {
        editor-open-rw = ''$$EDITOR $f'';
        editor-open-ro = ''$$EDITOR -R $f'';
      };
      settings = {
        preview = true;
        drawbox = true;
        icons = true;
        ignorecase = true;
      };
      keybindings = {
        w = "editor-open-rw";
        r = "editor-open-ro";
      };
      extraConfig = let
        previewer = pkgs.writeShellScriptBin "pv.sh" ''
          file=$1
          w=$2
          h=$3
          x=$4
          y=$5

          if [[ "$( ${pkgs.file}/bin/file -Lb --mime-type "$file")" =~ ^image ]]; then
            ${pkgs.kitty}/bin/kitty +kitten icat --silent --stdin no --transfer-mode file --place "''${w}x''${h}@''${x}x''${y}" "$file" < /dev/null > /dev/tty
            exit 1
          fi

          ${pkgs.pistol}/bin/pistol "$file"
        '';
        cleaner = pkgs.writeShellScriptBin "clean.sh" ''
          ${pkgs.kitty}/bin/kitty +kitten icat --clear --stdin no --silent --transfer-mode file < /dev/null > /dev/tty
        '';
      in ''
        set cleaner ${cleaner}/bin/clean.sh
        set previewer ${previewer}/bin/pv.sh
      '';
    };
  };
}
