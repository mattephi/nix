{
  inputs,
  ...
}:
{
  system.stateVersion = "25.05";

  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  imports = [
    inputs.overlays
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.simple-nixos-mailserver.nixosModule
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
    ./modules
    ./disk-config.nix
    ./hardware-configuration.nix
  ];

  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
}
