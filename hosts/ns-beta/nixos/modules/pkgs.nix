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

  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl."net.ipv4.tcp_congestion_control" = "bbr";
  boot.kernel.sysctl."net.core.default_qdisc" = "fq";

  security.rtkit.enable = true; # Real-time scheduling
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      80
      443
    ];
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

  services.xray = {
    enable = true;
    settingsFile = "${config.sops.templates."xray".path}";
  };
}
