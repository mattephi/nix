{
  description = "mattenix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    hyprland.url = "github:hyprwm/Hyprland";
    nix-wallpaper.url = "github:lunik1/nix-wallpaper";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      disko,
      stylix,
      nixpkgs,
      hyprland,
      sops-nix,
      nixpkgs-xr,
      home-manager,
      nix-index-database,
      nix-vscode-extensions,
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
      nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
      # Available through 'nixos-rebuild --flake .#mattenix'
      nixosConfigurations = {
        mattenix = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs system;
          };
          modules = [
            { nixpkgs.overlays = overlays; }
            sops-nix.nixosModules.sops
            ./hosts/mattenix/nixos/configuration.nix
            stylix.nixosModules.stylix

            nixpkgs-xr.nixosModules.nixpkgs-xr
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.users.mattephi = ./hosts/mattenix/home/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
        ns-alpha = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          system = "x86_64-linux";
          modules = [
            { nixpkgs.overlays = overlays; }
            disko.nixosModules.disko
            sops-nix.nixosModules.sops
            ./hosts/ns-alpha/nixos/configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.users.mattephi = ./hosts/ns-alpha/home/home.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
              };
            }
          ];
        };
      };
    };
}
