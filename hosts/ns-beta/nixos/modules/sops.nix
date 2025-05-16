{ config, ... }:
{
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      "APP_PORT" = {
        format = "json";
        sopsFile = ../secrets/remnawave.json;
      };
      "SSL_CERT" = {
        format = "json";
        sopsFile = ../secrets/remnawave.json;
      };
      "Caddyfile" = {
        format = "binary";
        sopsFile = ../secrets/Caddyfile;
      };
    };

    templates = {
      "remnanode.env".content = ''
        APP_PORT=${config.sops.placeholder."APP_PORT"}
        SSL_CERT=${config.sops.placeholder."SSL_CERT"}
      '';
      "Caddyfile" = {
        owner = "caddy";
        content = ''${config.sops.placeholder."Caddyfile"}'';
      };
    };
  };
}
