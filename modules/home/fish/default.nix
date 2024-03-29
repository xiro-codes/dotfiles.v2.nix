{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local;
in {
  options.local.fish.enable = mkOption {
    type = types.bool;
    default = cfg.enable;
  };
  config = mkIf cfg.fish.enable {
    home.packages = with pkgs; [oh-my-fish];
    programs = {
      eza = {
        enable = true;
      };
      zoxide = {
        enable = true;
      };
      fish = {
        enable = true;
        shellAbbrs = {
          ls = "eza --icons always";
          gcd = ''git commit -m "$(date)"'';
          osb = ''nh os switch'';
          hmb = ''nh home switch'';
          cd = "z";
          tcd = "cd \$(mktemp -d)";
          lsa = "eza --icons always --all";
          lgit = "lazygit";
          fm = "joshuto";
          du = "dust";
          df = "duf";
        };
        functions = {
        };
        #fish_vi_key_bindings
        interactiveShellInit = ''
          set -g fish_color_normal 3760bf
          set -g fish_color_command 007197
          set -g fish_color_keyword 9854f1
          set -g fish_color_quote 8c6c3e
          set -g fish_color_redirection 3760bf
          set -g fish_color_end b15c00
          set -g fish_color_error f52a65
          set -g fish_color_param 7847bd
          set -g fish_color_comment 848cb5
          set -g fish_color_selection --background=b6bfe2
          set -g fish_color_search_match --background=b6bfe2
          set -g fish_color_operator 587539
          set -g fish_color_escape 9854f1
          set -g fish_color_autosuggestion 848cb5

          set -g fish_pager_color_progress 848cb5
          set -g fish_pager_color_prefix 007197
          set -g fish_pager_color_completion 3760bf
          set -g fish_pager_color_description 848cb5
          set -g fish_pager_color_selected_background --background=b6bfe2
          zoxide init fish | source
        '';
      };
    };
  };
}
