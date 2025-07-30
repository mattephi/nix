{ config, ... }:
let
  hostname = "rss.mattephi.com";
  url = "https://${hostname}";
in
{
  sops.secrets.freshrss-pass-mattephi = {
    owner = "freshrss";
    format = "json";
    sopsFile = ./passwords.json;
    key = "mattephi";
  };

  services.freshrss = {
    enable = true;
    webserver = "caddy";
    baseUrl = url;
    defaultUser = "mattephi";
    passwordFile = config.sops.secrets.freshrss-pass-mattephi.path;
    virtualHost = hostname;
  };
}
