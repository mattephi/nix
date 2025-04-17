{ inputs, pkgs, ... }:
{
  home = {
    username = "mattephi";
    homeDirectory = "/home/mattephi";
    stateVersion = "25.05";
  };

  # Enable home-manager self-management
  programs.home-manager.enable = true;

  xdg.desktopEntries = {
    code = {
      exec = "code --use-gl=desktop %F";
      icon = "vscode";
      mimeType = [ "x-scheme-handler/vscode" ];
      name = "Visual Studio Code";
      startupNotify = true;
      type = "Application";
    };
    code-url-handler = {
      exec = "code --use-gl=desktop --open-url %U";
      icon = "vscode";
      mimeType = [ "x-scheme-handler/vscode" ];
      name = "Visual Studio Code - URL Handler";
      noDisplay = true;
      startupNotify = true;
      type = "Application";
    };
  };

  home.packages = with pkgs; [
    # Discord without GPU acceleration
    (pkgs.writeShellApplication {
      name = "discord";
      text = "${pkgs.discord}/bin/discord --use-gl=desktop";
    })
    (pkgs.makeDesktopItem {
      name = "discord";
      exec = "discord";
      desktopName = "Discord";
    })
    # VSCode without GPU acceleration
    # NOTE: it is non-fhs version, hence plugin
    # management should be manual
    # (pkgs.writeShellApplication {
    #   name = "code";
    #   text = "${pkgs.vscode}/bin/code --use-gl=desktop";
    # })
    # (pkgs.makeDesktopItem {
    #   name = "Visual Studio Code";
    #   exec = "code";
    #   desktopName = "Visual Studio Code";
    # })
    # Logseq with explicit sync
    (pkgs.writeShellApplication {
      name = "logseq";
      text = "${pkgs.logseq}/bin/logseq --enable-features=WaylandLinuxDrmSyncobj";
    })
    (pkgs.makeDesktopItem {
      name = "logseq";
      exec = "logseq";
      desktopName = "Logseq";
    })
    # Google Chrome with explicit sync
    (pkgs.writeShellApplication {
      name = "google-chrome-stable";
      text = "${pkgs.google-chrome}/bin/google-chrome-stable --enable-features=WaylandLinuxDrmSyncobj";
    })
    (pkgs.makeDesktopItem {
      name = "google-chrome-stable";
      exec = "google-chrome-stable";
      desktopName = "Google Chrome";
    })
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
