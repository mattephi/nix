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
    # qutebrowser.enable = true;
    # qutebrowser.package = pkgs.qutebrowser.override {
    #   enableVulkan = true;
    #   enableWideVine = true;
    # };
    git = {
      enable = true;
      userName = "mattephi";
      userEmail = "contact@mattephi.com";
      extraConfig = {
        init.defaultBranch = "master";
      };
    };
  };

  stylix.targets.waybar.enable = false;

  home.packages = with pkgs; [
    gcc # TODO: remove
    vlc
    sops
    nixd
    nemo
    neovim
    ffmpeg
    devenv
    zotero
    discord
    gifsicle
    obsidian-fhs
    hyprshot
    oculante
    xorg.xeyes
    apple-cursor # XCURSOR theme
    google-chrome
    telegram-desktop
    nixfmt-rfc-style
    nix-output-monitor

    # Wine support
    # wineWowPackages.staging
    # wineWowPackages.waylandFull
  ];

  # Gracefully handle services restart
  systemd.user.startServices = "sd-switch";

  imports = [
    inputs.nix-index-database.homeModules.nix-index
    ./apps
  ];
}
