{ pkgs, ... }:
{
  nix.settings.trusted-users = [
    "root"
    "mattephi"
  ];

  users = {
    users = {
      mattephi = {
        isNormalUser = true;
        description = "mattephi";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
          "adbusers"
        ];
        shell = pkgs.fish;
      };
    };
  };
}
