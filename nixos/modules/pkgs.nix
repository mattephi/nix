{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.cudaSupport = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.rtkit.enable = true; # Real-time scheduling
  virtualisation.docker.enable = true;
  networking.networkmanager.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  environment.systemPackages = with pkgs; [
    btop # System monitor
    dunst # Notification daemon
    libnotify
    home-manager
    pavucontrol
    egl-wayland
    texlive.combined.scheme-full
  ];

  programs = {
    zsh.enable = true;
    nm-applet.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
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

      wireplumber.extraConfig."10-bluez" = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [
            "hsp_hs"
            "hsp_ag"
            "hfp_hf"
            "hfp_ag"
          ];
        };

        extraConfig.pipewire = {
          "10-airplay" = {
            "context.modules" = [
              {
                name = "libpipewire-module-raop-discover";
              }
            ];
          };
        };
      };
    };
  };
}
