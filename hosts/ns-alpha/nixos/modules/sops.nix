{ config, ... }:
{
  sops = {
    defaultSopsFile = ../../../../secrets/config.py;
    age.keyFile = "/var/lib/sops-nix/key.txt";

    secrets."config.py" = {
      format = "binary";
      key = "";
    };

    templates = {
      "config.py".content = ''${config.sops.placeholder."config.py"}'';
    };
  };
}
