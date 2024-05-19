install DEVICE HOST=`hostname`:
	nix run github:nix-community/disko -- --mode disko systems/x86_64-linux/{{HOST}}/disk-configuration.nix --arg device '"{{DEVICE}}"'
	nixos-install 

rebuild:
	sudo nixos-rebuild switch

update-rebuild:
	nix flake update 
	sudo nixos-rebuild switch --upgrade
