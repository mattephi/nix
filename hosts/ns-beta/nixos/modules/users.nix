{ pkgs, ... }:
let
  # Per-machine SSH keys (rotated 2026). The legacy mattenix/id_iris key is
  # kept temporarily as break-glass and removed once the new keys are verified.
  authorizedKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZNtog6rKlds6X+Ci1ddrngoBL1xprPE8emkymseybN mattephi@mattenix"
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
