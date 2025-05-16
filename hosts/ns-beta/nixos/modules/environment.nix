{ pkgs, ... }:
{
  networking.hostName = "ns-beta";
  security.sudo.wheelNeedsPassword = false;

  environment = {
    shells = [
      pkgs.fish
    ];
  };
}
