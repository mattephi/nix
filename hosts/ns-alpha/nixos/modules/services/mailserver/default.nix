{ config, ... }:
{
  sops.secrets.mailserver-p1 = {
    format = "json";
    sopsFile = ./passwords.json;
    key = "mattephi";
  };
  sops.secrets.mailserver-p2 = {
    format = "json";
    sopsFile = ./passwords.json;
    key = "rwbin";
  };
  sops.secrets.mailserver-p3 = {
    format = "json";
    sopsFile = ./passwords.json;
    key = "contact";
  };

  mailserver = {
    enable = true;
    stateVersion = 3;
    fqdn = "mail.mattephi.com";
    domains = [ "mattephi.com" ];

    loginAccounts = {
      "mattephi@mattephi.com" = {
        hashedPasswordFile = config.sops.secrets.mailserver-p1.path;
        aliases = [ "postmaster@mattephi.com" ];
      };
      "rwbin@mattephi.com" = {
        hashedPasswordFile = config.sops.secrets.mailserver-p2.path;
        aliases = [
          "rwbin@mattephi.com"
          "rw@mattephi.com"
        ];
      };
      "contact@mattephi.com" = {
        hashedPasswordFile = config.sops.secrets.mailserver-p3.path;
      };
    };
    certificateScheme = "manual";
    certificateFile = "/mail.crt";
    keyFile = "/mail.key";
  };
}
