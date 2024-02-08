{
  config,
  lib,
  ...
}: let
  cfg = config.local.anime-hub;
in
  with lib; {
    imports = [
      ./server.nix
      ./containers
    ];
    options.local.anime-hub = {
      enable = mkEnableOption "anime-hub";
    };
    config.local = mkIf cfg.enable {
      anime-hub = {
        #security.enable = false;
        #metrics = {
        #  enable = false;
        #  domainName = "ruby.dashboard";
        #  collectorPort = 9002;
        #  managementPort = 9001;
        #  dashboardPort = 9000;
        #};

        server = {
          enable = true;
          bond = {
            addr = "127.0.0.1";
            port = 80;
          };
        };

        containers = {
          mediaFolder = "/mnt/backup/videos/Anime";
          #portRange = range 8000 9000;
          pihole = {
            enable = true;
            domainName = "ruby.admin";
            hostPort = 8080;
          };
          komga = {
            enable = true;
            domainName = "ruby.library";
            hostPort = 8081;
          };
          lanraragi = {
            enable = true;
            domainName = "ruby.lanraragi";
            hostPort = 8084;
          };
          jellyfin = {
            enable = true;
            domainName = "ruby.media";
            hostPort = 8082;
          };
          shoko = {
            enable = true;
            domainName = "ruby.metadata";
            hostPort = 8083;
          };
        };
      };
    };
  }
