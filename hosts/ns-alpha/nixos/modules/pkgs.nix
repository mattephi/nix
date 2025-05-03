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
    enableNvidia = true;
    extraOptions = "--default-runtime=nvidia";
  };
  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    glib
    unzip
  ];

  programs = {
    fish.enable = true;
  };

  services = {

  };
}
