{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = {
    self,
    nixpkgs,
    snowfall-lib,
    ...
  } @ inputs:
    snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      systems.modules.nixos = with inputs; [
        disko.nixosModules.default
        nixos-generators.nixosModules.all-formats
      ];

      systems.hosts.Ruby.modules = with inputs; [
        jovian.nixosModules.default
      ];

      homes.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
      ];

      channels-config = {
        # Allow unfree packages.
        allowUnfree = true;
        permittedInsecurePackages = [
          "nix-2.16.2"
        ];
      };
    };
}
