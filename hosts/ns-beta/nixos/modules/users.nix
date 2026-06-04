{ pkgs, ... }:
let
  # Per-machine SSH keys (rotated 2026). Legacy mattenix/id_iris key retired
  # after the new keys were verified working.
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDYzVABL0KoL3Otza51qpupTg04Bp5ktUIZIITDBE81+ mattephi@matteair"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJpIwc7B7A7s9tjSiEsZllat0KfsSHqPLu7oyIRffytF mattephi@mattemini"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGxsn8ZpStgoG8x2XvJNw7Iyx//oYasfBhMBglC1XJ00 alent@mattewin"
  ];
in
{
  users = {
    users = {
      mattephi = {
        isNormalUser = true;
        description = "mattephi";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];

        shell = pkgs.fish;

        openssh.authorizedKeys.keys = authorizedKeys;
      };

      root = {
        openssh.authorizedKeys.keys = authorizedKeys;
      };
    };
  };
}
