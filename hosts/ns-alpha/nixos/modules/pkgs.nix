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

  imports = [
    ./services
    ./containers
  ];

  security.rtkit.enable = true; # Real-time scheduling
  services.journald.storage = "persistent";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      443
      8443
    ];
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  programs = {
    fish.enable = true;
  };
}
