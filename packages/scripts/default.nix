{	lib, pkgs, symlinkJoin, writeShellApplication ,...}: let 
	sunset = writeShellApplication {
		name = "sunset";
		runtimeInputs = [pkgs.wlsunset];
		text = ''
			wlsunset -S 6:00 -s 17:00
		'';
	};
	lock = writeShellApplication {
		name = "lock";
		runtimeInputs = [pkgs.swaylock];
		text = ''
			swaylock --screenshots \
							 --clock \
							 --indicator \
							 --datestr "%m-%d" \
							 --effect-blur 7x5 \
							 --ring-color 282828\
							 --key-hl-color 9ECE6A \
							 --text-color 7DCFFF \
							 --line-color 00000000 \
          		 --inside-color 00000088 \
          		 --separator-color 00000000 \
          		 --effect-pixelate 40
		'';
	};

  launch_hud = pkgs.writeShellScriptBin "launch_hud" ''
		${pkgs.eww}/bin/eww open-many --toggle apps apps1 clock clock1 music music1
  '';

  launch_dash = pkgs.writeShellScriptBin "launch_dash" ''
		${pkgs.eww}/bin/eww open-many --toggle resources quotes logout lock shutdown suspend reboot; 
  '';

	show_dash = pkgs.writeShellScriptBin "show_dash" ''
		${pkgs.eww}/bin/eww open-many --toggle resources quotes logout lock shutdown suspend reboot; 
		sleep 10;
		${pkgs.eww}/bin/eww close resources quotes logout lock shutdown suspend reboot; 
	'';
in symlinkJoin {
	name = "scripts";
	paths = [ sunset lock launch_hud launch_dash show_dash ];
}
