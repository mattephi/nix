# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

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
