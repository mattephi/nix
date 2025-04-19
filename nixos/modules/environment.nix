{ pkgs, ... }:
{
  networking.hostName = "mattenix";
  security.sudo.wheelNeedsPassword = false;

  environment = {
    shells = [ pkgs.zsh ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Force wayland
      WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursors on hyprland
    };
  };
}
