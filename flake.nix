{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    snowfall-lib = {
      url = "github:snowfallorg/lib/dev";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";

    niri = {
      url = "github:YaLTeR/niri";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hdhomerun-client.url = "github:xiro-codes/hdhomerun-client";
    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix";
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
        aagl.nixosModules.default
      ];

      systems.hosts.Ruby.modules = with inputs; [
        jovian.nixosModules.default
      ];
      systems.hosts.Sapphire.modules = with inputs; [
      ];

      homes.modules = with inputs; [
        nixvim.homeManagerModules.nixvim
        impermanence.nixosModules.home-manager.impermanence
      ];

      channels-config = {
        # Allow unfree packages.
        allowUnfree = true;
      };
    };
}
