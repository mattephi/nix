{
  system.stateVersion = "25.05";

  imports = [
    ./modules/pkgs.nix
    ./modules/fonts.nix
    ./modules/users.nix
    ./modules/nvidia.nix
    ./modules/locale.nix
    ./modules/environment.nix
    ./modules/hardware-extra.nix
    ./hardware-configuration.nix
  ];
}
