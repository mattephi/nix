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
      25
      80
      443
      465
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
