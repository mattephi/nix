{ pkgs, ... }:
{
  services.caddy = {
    enable = true;
    globalConfig = ''
      order webdav before file_server
    '';
    virtualHosts = {
      "webdav.mattephi.com".extraConfig = ''
        root * /data/webdav
        basic_auth {
          mattephi $2a$12$9iuTVmVmQdwhbcR5fpWT0e1ivXkpxbnj1TOQdoNescN0yPt7bbcti
        }
        webdav
      '';
      "show.mattephi.com".extraConfig = ''
        @root {
          path /
        }
        root @root /srv/show/_site
        file_server @root

        @subdirs {
          not path /
        }
        root @subdirs /srv/show
        file_server @subdirs
      '';
      "time.mattephi.com".extraConfig = ''
        reverse_proxy /* {
          to localhost:9011
        }

        # proxy API
        reverse_proxy /api/* {
          to localhost:9010
          header_up Authorization {http.request.header.Authorization}
        }
      '';
    };
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20250805175825-7a5c90d8bf90"
      ];
      hash = "sha256-Pf72UOUp0qIQw9JtuZB5CxIHERP19MZ2j4C0PNvrzcA=";
    };
  };
}
