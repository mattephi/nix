{
  description = "mattenix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      hyprland,
      home-manager,
      nix-vscode-extensions,
      nix-index-database,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      overlays = [
        nix-vscode-extensions.overlays.default
        (import ./overlays/first.nix)
      ];
    in
    {
      # Available through 'nixos-rebuild --flake .#mattenix'
      nixosConfigurations.mattenix = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs outputs system;
          inherit (inputs) hyprland;
        };
        modules = [
          { nixpkgs.overlays = overlays; }
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "hm-backup";
            home-manager.users.mattephi = ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs;
              inherit (inputs) nix-index-database;
            };
          }
        ];
      };
    };
}
