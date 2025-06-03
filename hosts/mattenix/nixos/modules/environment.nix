{ pkgs, ... }:
{
  networking.hostName = "mattenix";
  security.sudo.wheelNeedsPassword = false;

  environment = {
    shells = [
      pkgs.zsh
      pkgs.fish
    ];

    sessionVariables = {
      NIXOS_OZONE_WL = "1"; # Force wayland
      WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursors on hyprland
      WEBKIT_DISABLE_DMABUF_RENDERER = "1"; # Fix webkit on hyprland
      EDITOR = pkgs.neovim; # Default editor
      NO_AT_BRIDGE = "1"; # Disable AT-SPI bridge
    };
  };
}
