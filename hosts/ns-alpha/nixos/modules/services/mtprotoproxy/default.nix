{
  config,
  pkgs,
  lib,
  ...
}:
{
  sops.secrets."mtpp.config.py" = {
    format = "binary";
    sopsFile = ./config.py;
  };

  services.mtprotoproxy = {
    enable = true;
    users = { };
  };

  systemd.services.mtprotoproxy.serviceConfig = {
    LoadCredential = [ "config:${config.sops.secrets."mtpp.config.py".path}" ];
    ExecStart = lib.mkForce ''
      ${
        pkgs.mtprotoproxy.overrideAttrs (old: {
          version = "latest";
          patches = old.patches or [ ] ++ [
            ./0-disable-pool.patch
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
