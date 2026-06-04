{
  description = "mattenix flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  # Recent nixpkgs used only to build mtg (needs Go >= 1.26, absent from the
  # pinned system nixpkgs). Keeps the rest of the system on the stable pin.
  inputs.nixpkgs-bleed.url = "github:nixos/nixpkgs/331800de5053fcebacf6813adb5db9c9dca22a0c";
  inputs.home-manager.url = "github:nix-community/home-manager";
  inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.sops-nix.url = "github:Mic92/sops-nix";
  inputs.sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  inputs.simple-nixos-mailserver.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
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
        ns-beta = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs system;
          };
          modules = [
            ./hosts/ns-beta/nixos/configuration.nix
          ];
        };
        ns-gamma = inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs system;
          };
          modules = [
            ./hosts/ns-gamma/nixos/configuration.nix
          ];
        };
      };
    };
}
