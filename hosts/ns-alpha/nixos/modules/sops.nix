{ config, ... }:
{
  sops = {
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."config.py" = {
      format = "binary";
      sopsFile = ../../../../secrets/config.py;
    };

    secrets."Caddyfile" = {
      format = "binary";
      sopsFile = ../../../../secrets/Caddyfile;
    };

    templates = {
      "config.py".content = ''${config.sops.placeholder."config.py"}'';
      "Caddyfile" = {
        owner = "caddy";
        content = ''${config.sops.placeholder."Caddyfile"}'';
      };
    };
  };
}
