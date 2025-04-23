{
  pkgs,
  hyprland,
  system,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.rtkit.enable = true; # Real-time scheduling
  virtualisation.docker = {
    enable = true;
    enableNvidia = true;
    extraOptions = "--default-runtime=nvidia";
  };
  networking.networkmanager.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [
    glib
    btop # System monitor
    dunst # Notification daemon
    unzip
    libnotify
    pavucontrol
    egl-wayland
    home-manager
    texlive.combined.scheme-full

    # Required for some applications
    # For example Isaac
    libGL
    libGLU
    util-linux
    xorg.libSM
    xorg.libXt
    xorg.libICE
    xorg.libX11
    libxcrypt-legacy
  ];

  programs = {
    zsh.enable = true;
    fish.enable = true;
    nm-applet.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
      package = hyprland.packages.${system}.hyprland;
      portalPackage = hyprland.packages.${system}.xdg-desktop-portal-hyprland;
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

    wivrn = {
      enable = true;
      defaultRuntime = true;
    };

    xserver = {
      enable = true;
      exportConfiguration = true;
      screenSection = ''
        Option "metamodes" "nvidia-auto-select +0+0 { ForceFullCompositionPipeline = On }"
        Option "TripleBuffer" "on"
      '';

      displayManager.gdm = {
        enable = true;
        wayland = true;
      };

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
