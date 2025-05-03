{
  pkgs,
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
    git
    unzip
  ];

  programs = {
    fish.enable = true;
  };

  services = {
    openssh.enable = true;
  };
}
