{ inputs, pkgs, ... }:
{
  home = {
    username = "mattephi";
    homeDirectory = "/home/mattephi";
    stateVersion = "25.05";
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "mattephi";
      userEmail = "contact@mattephi.com";
      extraConfig = {
        init.defaultBranch = "master";
      };
    };
  };

  home.packages = with pkgs; [
    zotero
    logseq
    discord
    krusader # File manager
    xorg.xeyes
    apple-cursor # XCURSOR theme
    rofi-wayland # Application launcher
    google-chrome
    wlx-overlay-s # VR overlay
    telegram-desktop
    nixfmt-rfc-style
  ];

  # Gracefully handle services restart
  systemd.user.startServices = "sd-switch";

  imports = [
    # Hyprland configuration
    ./modules/zsh.nix
    ./modules/fish.nix
    ./modules/waybar.nix
    ./modules/vscode.nix
    ./modules/zathura.nix
    ./modules/ghostty.nix
    ./modules/hyprland.nix
    ./modules/nix-index.nix
  ];
}
