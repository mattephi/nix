{ pkgs, ... }:
{
  networking.hostName = "mattenixs";
  security.sudo.wheelNeedsPassword = false;

  environment = {
    shells = [
      pkgs.fish
    ];
  };
}
