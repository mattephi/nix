{ config, pkgs, ... }:
{
  sops.secrets.Caddyfile = {
    format = "binary";
    owner = "caddy";
    sopsFile = ./Caddyfile;
  };

  services.caddy = {
    enable = true;
    configFile = config.sops.secrets.Caddyfile.path;
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20241008162340-42168ba04c9d"
        "github.com/mholt/caddy-l4@v0.0.0-20250428144642-57989befb7e6"
      ];
      hash = "sha256-h7Fiztrk+znBXSl8NI7V2D2S8Lt1h1F1XbOJG5NJHZE=";
    };
  };
}
