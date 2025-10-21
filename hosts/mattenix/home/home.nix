{
  inputs,
  pkgs,
  ...
}:
{
  home = {
    username = "mattephi";
    homeDirectory = "/home/mattephi";
    stateVersion = "25.05";
  };

  services.hyprpaper.enable = true;

  programs = {
    home-manager.enable = true;
    direnv.enable = true;
    btop.enable = true;
    git = {
      enable = true;
      settings = {
        user.name = "mattephi";
        user.email = "contact@mattephi.com";
        init.defaultBranch = "master";
      };
    };
  };

  stylix.targets.waybar.enable = false;
  stylix.polarity = "dark";

  home.packages = with pkgs; [
    vlc
    sops
    nixd
    nemo
    neovim
    ffmpeg
    devenv
    nomacs
    zotero
    discord
    hyprshot
    obs-studio
    obsidian-fhs
    apple-cursor
    google-chrome
    telegram-desktop
    nixfmt-rfc-style
  ];

  # Gracefully handle services restart
  systemd.user.startServices = "sd-switch";

  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./apps
  ];
}
