{
  description = "mattenix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
      overlays = [ (import ./overlays/first.nix) ];
    in
    {
      # Available through 'nixos-rebuild --flake .#mattenix'
      nixosConfigurations.mattenix = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs system; };
        modules = [
          { nixpkgs.overlays = overlays; }
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.mattephi = ./home-manager/home.nix;
            home-manager.extraSpecialArgs = {
              inherit inputs outputs system;
            };
          }
        ];
      };
    };
}
