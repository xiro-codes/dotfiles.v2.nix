{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local.anime-hub.server;
in {
  options.local.anime-hub.server = with types; {
    enable = mkEnableOption "configure anime-hub's nginx server";
    bond = mkOption {
      type = attrsOf anything;
      description = "an address and port for nginx to listen on";
      default = {
        addr = "127.0.0.1";
        port = 80;
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
    };
  };
}
