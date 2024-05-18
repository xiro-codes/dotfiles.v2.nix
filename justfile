install HOST:
	nix run github:nix-community/disko -- --mode disko systems/x86_64-linux/{{HOST}}/disk-configuration.nix --arg device '"/dev/nvme0n1"'
	nixos-install 
