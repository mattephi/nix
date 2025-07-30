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
    };
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20241008162340-42168ba04c9d"
        "github.com/mholt/caddy-l4@v0.0.0-20250428144642-57989befb7e6"
      ];
      hash = "sha256-CvQaau5vH2oaqO9DQjXbLEhA0UYyMzN3zgpO8aQ0pF0=";
    };
  };
}
