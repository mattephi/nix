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
    };
    certificateScheme = "manual";
    certificateFile = "/mail.crt";
    keyFile = "/mail.key";
  };
}
