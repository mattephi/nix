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
    enable = true;
  };
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3366 ];
  };

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

  services.mtprotoproxy = {
    enable = true;
    users = { };
  };

  systemd.services.mtprotoproxy.serviceConfig = {
    LoadCredential = [ "config:${config.sops.templates."config.py".path}" ];
    ExecStart = lib.mkForce ''
      ${pkgs.mtprotoproxy}/bin/mtprotoproxy ''${CREDENTIALS_DIRECTORY}/config
    '';
  };
}
