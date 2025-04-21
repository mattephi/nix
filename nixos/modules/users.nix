{ pkgs, ... }:
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
      };
    };
  };
}
