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
    qutebrowser.enable = true;
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
    gcc # TODO: remove
    sops
    nixd
    nemo
    codex # TODO: configure secret
    neovim
    devenv
    zotero
    logseq # TODO: remove
    discord
    obsidian-fhs
    hyprshot
    oculante
    xorg.xeyes
    apple-cursor # XCURSOR theme
    google-chrome
    # wlx-overlay-s # VR overlay
    telegram-desktop
    nixfmt-rfc-style
    nix-output-monitor

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
