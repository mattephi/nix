{ config, ... }:
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
    baseUrl = "https://rss.mattephi.com";
    defaultUser = "mattephi";
    passwordFile = config.sops.secrets.freshrss-pass-mattephi.path;
    virtualHost = "rss.mattephi.com";
  };
}
