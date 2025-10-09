{ config, ... }:
let
  hostname = "fire.mattephi.com";
  url = "https://${hostname}";
  webserver = config.services.caddy;
in
{
  sops.secrets.app-key = {
    format = "binary";
    sopsFile = ./app-key;
    owner = config.services.firefly-iii.user;
  };

  services.firefly-iii = {
    enable = true;
    user = webserver.user;
    group = webserver.group;
    enableNginx = false;
    virtualHost = hostname;
    settings = {
      APP_URL = url;
      APP_KEY_FILE = config.sops.secrets.app-key.path;
      ENABLE_EXCHANGE_RATES = true;
      ENABLE_EXTERNAL_RATES = true;
    };
  };

  services.caddy.virtualHosts."${hostname}".extraConfig = ''
    root * ${config.services.firefly-iii.package}/public

    php_fastcgi unix/${config.services.phpfpm.pools.firefly-iii.socket} {
      env modHeadersAvailable true
    }

    file_server
  '';
}
