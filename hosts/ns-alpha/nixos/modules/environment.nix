{ pkgs, ... }:
{
  networking.hostName = "ns-alpha";
  security.sudo.wheelNeedsPassword = false;

  environment = {
    shells = [
      pkgs.fish
    ];
  };
}
