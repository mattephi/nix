{
  description = "mattenix flake";

  inputs = {
    # nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # Hyprland
    hyprland.url = "github:hyprwm/Hyprland";
    niri.url = "github:sodiboo/niri-flake";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      niri,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      system = "x86_64-linux";
    in
    {
      # Available through 'nixos-rebuild --flake .#mattenix'
      nixosConfigurations = {
        mattenix = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs outputs system; };
          modules = [
            ./nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.mattephi = ./home-manager/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs outputs system;
              };
            }
          ];
        };
      };
    };
}
