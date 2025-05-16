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

  # TODO: Remnawave running on the host
  # implement declaratively instead.
  # Issue: unable to pass secret to the
  # prisma run to resolve DB connection.

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

  services = {
    openssh.enable = true;
  };

  services.mtprotoproxy = {
    enable = true;
    users = { };
  };

  services.caddy = {
    enable = true;
    configFile = "${config.sops.templates."Caddyfile".path}";
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20241008162340-42168ba04c9d"
        "github.com/mholt/caddy-l4@v0.0.0-20250428144642-57989befb7e6"
      ];
      hash = "sha256-QeT6d1OshCZnamY89VPpRL58lwWB1kfsjHN/GsNlZpc=";
    };
  };

  # TODO: move mtprotoproxy to ns-beta

  systemd.services.mtprotoproxy.serviceConfig = {
    LoadCredential = [ "config:${config.sops.templates."config.py".path}" ];
    ExecStart = lib.mkForce ''
      ${
        pkgs.mtprotoproxy.overrideAttrs (old: {
          version = "latest";
          patches = old.patches or [ ] ++ [
            ../../../../overlays/modules/mtprotoproxy/0-disable-pool.patch
          ];
          src = pkgs.fetchFromGitHub {
            owner = "alexbers";
            repo = "mtprotoproxy";
            rev = "bc841cff482a72472f15a36f86ca01aa11cac58b";
            sha256 = "4wBHjtI0UYzmzLi8cESt4pjN1SgI5fwke8iwuaIVEFk=";
          };
        })
      }/bin/mtprotoproxy ''${CREDENTIALS_DIRECTORY}/config
    '';
  };
}
