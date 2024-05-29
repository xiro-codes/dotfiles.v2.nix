{ pkgs,
	config,
	lib,
	inputs,
	...
}: let 
	inherit (inputs.self.packages.${pkgs.system}) hyprland-scripts;
	inherit (inputs.self.lib) reduce;
	inherit (lib) mkOption types mkIf;
	cfg = config.rice;
in {
	options.rice.hyprland = {
		enable = mkOption { type = types.bool; default = false;};
		background = mkOption {};
		autostart = mkOption {type = types.listOf types.str; };
		mod= mkOption { type = with types; enum ["SUPER_L" "ALT_L"];};
	};
}
