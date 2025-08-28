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
        openssh.authorizedKeys.keys = [
          # change this to your ssh key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZNtog6rKlds6X+Ci1ddrngoBL1xprPE8emkymseybN mattephi@mattenix"
        ];
      };
      root = {
        openssh.authorizedKeys.keys = [
          # change this to your ssh key
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZNtog6rKlds6X+Ci1ddrngoBL1xprPE8emkymseybN mattephi@mattenix"
        ];
      };
    };
  };
}
