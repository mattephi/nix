{
  description = "mattenix flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.stylix.url = "github:danth/stylix";
  inputs.hyprland.url = "github:hyprwm/Hyprland";
  inputs.nix-wallpaper.url = "github:lunik1/nix-wallpaper";
  inputs.nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  inputs.nix-index-database.url = "github:nix-community/nix-index-database";
  inputs.nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  outputs =
    { self, ... }@rawInputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      overlays = [
        rawInputs.nix-vscode-extensions.overlays.default
        (import ./overlays/first.nix)
      ];
      inputs = rawInputs // {
        overlays = {
          nixpkgs.overlays = overlays;
        };
      };
    in
    {
      nixosConfigurations = {
        mattenix = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs system;
          };
          modules = [
            ./hosts/mattenix/nixos/configuration.nix
          ];
        };
        ns-alpha = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs system;
          };
          modules = [
            ./hosts/ns-alpha/nixos/configuration.nix
          ];
        };
      };
    };
}
