{ pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;

    users = {
      mattephi = {
        isNormalUser = true;
        description = "mattephi";
        extraGroups = [
          "networkmanager"
          "wheel"
          "docker"
        ];
      };
    };
  };
}
