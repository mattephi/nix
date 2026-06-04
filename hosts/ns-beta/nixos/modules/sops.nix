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
      "xray" = {
        format = "json";
        sopsFile = ../secrets/xray.json;
        key = "";
      };
      "mtg-secret" = {
        format = "json";
        key = "secret";
        sopsFile = ../secrets/mtg.json;
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
      "xray" = {
        content = ''${config.sops.placeholder."xray"}'';
      };
      "mtg.toml".content = ''
        secret = "${config.sops.placeholder."mtg-secret"}"
        bind-to = "0.0.0.0:8443"
      '';
    };
  };
}
