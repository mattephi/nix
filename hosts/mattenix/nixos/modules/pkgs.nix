{
  inputs,
  pkgs,
  system,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.rtkit.enable = true; # Real-time scheduling
  virtualisation.docker = {
    enable = true;
  };
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    unzip
    libnotify
    egl-wayland
    pavucontrol
    home-manager
    nvidia-vaapi-driver
    texlive.combined.scheme-full
  ];

  programs = {
    zsh.enable = true;
    fish.enable = true;
    nm-applet.enable = true;
    adb.enable = true;

    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/mattephi/nix";
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = inputs.hyprland.packages.${system}.hyprland;
      portalPackage = inputs.hyprland.packages.${system}.xdg-desktop-portal-hyprland;
    };
  };

  systemd.user.services.mpris-proxy = {
    description = "Mpris proxy";
    after = [
      "network.target"
      "sound.target"
    ];
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
  };

  services = {
    avahi.enable = true;
    blueman.enable = true;
    printing.enable = true;
    pulseaudio.enable = false;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;

    displayManager.gdm = {
      enable = true;
      wayland = true;
    };

    xserver = {
      enable = true;
      exportConfiguration = true;
      # screenSection = ''
      #   Option "metamodes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
      #   Option "TripleBuffer" "on"
      # '';

      xkb = {
        layout = "us,ru";
        options = "grp:ctrl_space_toggle";
      };
    };

    pipewire = {
      enable = true;
      jack.enable = true;
      alsa.enable = true;
      pulse.enable = true;
      raopOpenFirewall = true;
      alsa.support32Bit = true;
    };
  };
}
