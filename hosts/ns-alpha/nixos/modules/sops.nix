{ config, ... }:
{
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets = {
      "config.py" = {
        format = "binary";
        sopsFile = ../secrets/config.py;
      };
      "Caddyfile" = {
        format = "binary";
        sopsFile = ../secrets/Caddyfile;
      };
      "open-webui.env" = {
        format = "dotenv";
        sopsFile = ../secrets/open-webui.env;
      };
      searx = {
        format = "binary";
        sopsFile = ../secrets/searx;
      };
      "litellm" = {
        format = "yaml";
        sopsFile = ../secrets/litellm.yaml;
        key = "";
      };
      "litellm.env" = {
        format = "dotenv";
        sopsFile = ../secrets/litellm.env;
      };
      "litellm.postgres.env" = {
        format = "dotenv";
        sopsFile = ../secrets/litellm.postgres.env;
      };
      "litellm.prometheus.yaml" = {
        format = "yaml";
        sopsFile = ../secrets/litellm.prometheus.yaml;
        key = "";
      };
    };

    templates = {
      "config.py".content = ''${config.sops.placeholder."config.py"}'';
      "Caddyfile" = {
        owner = "caddy";
        content = ''${config.sops.placeholder."Caddyfile"}'';
      };
      "open-webui.env".content = ''${config.sops.placeholder."open-webui.env"}'';
      searx.content = ''${config.sops.placeholder.searx}'';
      "litellm".content = ''${config.sops.placeholder."litellm"}'';
      "litellm.env".content = ''${config.sops.placeholder."litellm.env"}'';
      "litellm.postgres.env".content = ''${config.sops.placeholder."litellm.postgres.env"}'';
      "litellm.prometheus.yaml".content = ''${config.sops.placeholder."litellm.prometheus.yaml"}'';
    };
  };
}
