# Format disk and install
install DEVICE HOST=`hostname`:
	nix run github:nix-community/disko -- --mode disko systems/x86_64-linux/{{HOST}}/disk-configuration.nix --arg device '"{{DEVICE}}"'
	nixos-install --flake .#{{HOST}}
	mkdir -p /mnt/etc/nixos/
	cp -r ./* /mnt/etc/nixos/

# Build iso with nixos-generators
make-iso HOST=`hostname`:
	nix build .#nixosConfigurations.{{HOST}}.config.formats.install-iso
	mv result {{HOST}}.iso

rebuild:
	sudo nixos-rebuild switch

update-rebuild:
	nix flake update 
	sudo nixos-rebuild switch --upgrade

edit-home SYSTEM="x86_64-linux" USER=`whoami` HOST=`hostname`:
	nvim homes/{{SYSTEM}}/{{USER}}@{{HOST}}/default.nix

edit-system SYSTEM="x86_64-linux" HOST=`hostname`:
	nvim -o systems/{{SYSTEM}}/{{HOST}}/default.nix

edit-disk SYSTEM="x86_64-linux" HOST=`hostname`:
	nvim -O systems/{{SYSTEM}}/{{HOST}}/disk/*.nix
