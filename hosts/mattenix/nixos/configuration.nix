{ inputs, ... }:
{
  system.stateVersion = "25.05";

  imports = [
    inputs.overlays
    inputs.sops-nix.nixosModules.sops
    inputs.stylix.nixosModules.stylix
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "hm-backup";
      home-manager.users.mattephi = ../home/home.nix;
      home-manager.extraSpecialArgs = {
        inherit inputs;
      };
    }

    ./modules/pkgs.nix
    ./modules/fonts.nix
    ./modules/users.nix
    ./modules/stylix.nix
    ./modules/nvidia.nix
    ./modules/locale.nix
    ./modules/distributed.nix
    ./modules/environment.nix
    ./modules/hardware-extra.nix
    ./hardware-configuration.nix
  ];
}
