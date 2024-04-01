{
	pkgs,
		config,
		lib,
		inputs,
}: let
cfg = config.local;
self = cfg.deck;
inherit (lib) mkOption mkIf types mkEnableOption;
script = inputs.self.packages.${pkgs.system}.steam-mount;
in {
	options.local.deck.automount = {
		enable = mkEnableOption "automount and add drives to steam";
		user = mkOption {
			type = types.str;
			default = "deck";
		};
		patterns = mkOption {
			type = types.listOf types.str;
			default = ["sd[a-z][0-9]"]
		};
	};
	config = mkIf self.automount.enable {
		services.udev = {
			extraRules = strings.concatLines (map
					(pattern: ''
					 KERNEL=="${pattern}", ACTION=="add", RUN+="${pkgs.systemd}/bin/systemctl start --no-block jovian-automount@%k.service"
					 KERNEL=="${pattern}", ACTION=="remove", RUN+="${pkgs.systemd}/bin/systemctl stop --no-block jovian-automount@%k.service"
					 '')
					self.automount.patterns);
		};
		systemd.services."jovian-automount@" = {
			serviceConfig = {
				Type = "oneshot";
				RemainAfterExit = true;
				ExecStart = "${script}/bin/steam-mount add %i ${self.auotmount.user}";
				ExecStop = "${script}/bin/steam-mount remove %i";
			};
		};
	};
}
