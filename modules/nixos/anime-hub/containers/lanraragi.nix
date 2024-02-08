{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.local.anime-hub.containers.lanraragi;
  containerCfg = config.local.anime-hub.containers;
  serverCfg = config.local.anime-hub.server;
  self = {
    interfacePort = 3000;
    configFolder = "/";
  };
in
  with builtins; {
    options.local.anime-hub.containers.lanraragi = {
      enable = mkEnableOption "Setup lanraragi";
      domainName = mkOption {type = types.str;};
      hostPort = mkOption {type = types.port;};
    };
    config = mkIf cfg.enable {
      virtualisation.oci-containers.containers."${cfg.domainName}-lanraragi" = {
        image = "difegue/lanraragi";
        ports = ["${toString cfg.hostPort}:${toString self.interfacePort}"];
        volumes = [
          "lanraragi:${self.configFolder}"
          "${containerCfg.mediaFolder}:/media"
        ];
        autoStart = true;
      };
      services.nginx.virtualHosts.${cfg.domainName} = mkIf serverCfg.enable {
        listen = [
          serverCfg.bond
          {
            addr = serverCfg.bond.addr;
            port = 81;
          }
        ];
        locations."/" = {
          proxyPass = "http://localhost:${toString cfg.hostPort}";
        };
      };
    };
  }
