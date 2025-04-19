{ inputs, pkgs, ... }:
{
  home = {
    username = "mattephi";
    homeDirectory = "/home/mattephi";
    stateVersion = "25.05";
  };

  # Enable home-manager self-management
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    logseq
    discord
  ];

  # Git configuration
  programs.git = {
    enable = true;
    userName = "mattephi";
    userEmail = "contact@mattephi.com";
    extraConfig = {
      init.defaultBranch = "master";
    };
  };

  # Gracefully handle services restart
  systemd.user.startServices = "sd-switch";

  imports = [
    # Hyprland configuration
    ./modules/hyprland.nix
    ./modules/waybar.nix
    ./modules/ghostty.nix
    ./modules/zsh.nix
    ./modules/vscode.nix
    ./modules/zathura.nix
  ];
}
