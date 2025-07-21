{ config, pkgs, ... }:
{
  services.caddy = {
    enable = true;
    globalConfig = ''
      order webdav before file_server
    '';
    virtualHosts = {
      "maybe.mattephi.com".extraConfig = ''
        reverse_proxy http://127.0.0.1:3000
      '';
      "litellm.mattephi.com".extraConfig = ''
        reverse_proxy http://127.0.0.1:3004
      '';
      "mkfd.mattephi.com".extraConfig = ''
        reverse_proxy http://127.0.0.1:3005
      '';
      "search.mattephi.com".extraConfig = ''
        basic_auth { 
          mattephi $2a$12$.V6s5o/3Pt5UDVvVkRhIEeKTNbcx.C7WBpsA96PkkmyQqRiWns1Gm 
        }
        reverse_proxy http://127.0.0.1:3003
      '';
      "webdav.mattephi.com".extraConfig = ''
        root * /data/webdav
        basic_auth {
          mattephi $2a$12$9iuTVmVmQdwhbcR5fpWT0e1ivXkpxbnj1TOQdoNescN0yPt7bbcti
        }
        webdav
      '';
    };
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20241008162340-42168ba04c9d"
        "github.com/mholt/caddy-l4@v0.0.0-20250428144642-57989befb7e6"
      ];
      hash = "sha256-h7Fiztrk+znBXSl8NI7V2D2S8Lt1h1F1XbOJG5NJHZE=";
    };
  };
}
