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
    nemo
    codex
    zotero
    logseq
    discord
    hyprshot
    oculante
    xorg.xeyes
    apple-cursor # XCURSOR theme
    google-chrome
    wlx-overlay-s # VR overlay
    telegram-desktop
    nixfmt-rfc-style

    # Wine support
    wineWowPackages.staging
    # wineWowPackages.waylandFull

  ];

  # Gracefully handle services restart
  systemd.user.startServices = "sd-switch";

  imports = [
    inputs.nix-index-database.hmModules.nix-index
    ./apps
  ];
}
