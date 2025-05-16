{
  config,
  pkgs,
  lib,
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
    enable = false;
  };
  virtualisation.oci-containers.containers = {
    "remnanode" = {
      image = "remnawave/node:latest";
      hostname = "remnanode";
      networks = [ "host" ];
      environmentFiles = [
        config.sops.templates."remnanode.env".path
      ];
    };
  };
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      443
      45892
    ];
    interfaces.podman1 = {
      allowedUDPPorts = [ 53 ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];

  programs = {
    fish.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  services.jellyfin = {
    enable = true;
  };

  services.caddy = {
    enable = true;
    configFile = "${config.sops.templates."Caddyfile".path}";
  };
}
