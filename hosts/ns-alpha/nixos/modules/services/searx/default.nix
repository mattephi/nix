{ config, ... }:
{
  sops.secrets.searx = {
    format = "binary";
    sopsFile = ./searx;
  };

  services.searx = {
    enable = true;
    redisCreateLocally = true;

    # Rate limiting
    limiterSettings = {
      real_ip = {
        x_for = 1;
        ipv4_prefix = 32;
        ipv6_prefix = 56;
      };
    };

    runInUwsgi = true;

    uwsgiConfig = {
      disable-logging = true;
      socket = "/run/searx/searx.sock";
      http = "0.0.0.0:3003";
      chmod-socket = "660";
    };

    faviconsSettings = {
      favicons = {
        cfg_schema = 1;
        cache = {
          db_url = "/run/searx/faviconcache.db";
          HOLD_TIME = 5184000;
          LIMIT_TOTAL_BYTES = 2147483648;
          BLOB_MAX_BYTES = 40960;
          MAINTENANCE_MODE = "auto";
          MAINTENANCE_PERIOD = 600;
        };
      };
    };

    settings = {
      general = {
        debug = false;
        instance_name = "SearXNG";
        donation_url = false;
        contact_url = false;
        privacypolicy_url = false;
        enable_metrics = false;
      };

      # User interface
      ui = {
        static_use_hash = true;
        default_locale = "en";
        query_in_title = false;
        infinite_scroll = true;
        center_alignment = true;
        default_theme = "simple";
        theme_args.simple_style = "auto";
        search_on_category_select = false;
        url_formatting = "pretty";
        # hotkeys = "vim";
      };

      # Search engine settings
      search = {
        safe_search = 0;
        autocomplete_min = 2;
        autocomplete = "google";
        favicon_resolver = "google";
        default_lang = "auto";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
        formats = [
          "html"
          "json"
        ];
      };

      server = {
        base_url = "https://search.mattephi.com";
        port = 3002;
        bind_address = "127.0.0.1";
        secret_key = config.sops.secrets.searx.path;
        limiter = false;
        public_instance = false;
        image_proxy = true;
        method = "POST";
        default_http_headers = {
          X-Content-Type-Options = "nosniff";
          X-Download-Options = "noopen";
          X-Robots-Tag = "noindex, nofollow";
          Referrer-Policy = "no-referrer";
        };
      };

      outgoing = {
        request_timeout = 3.0;
        max_request_timeout = 10.0;
        pool_connections = 100;
        pool_maxsize = 15;
        enable_http2 = true;
      };

      enabled_plugins = [
        "Basic Calculator"
        "Hash plugin"
        "Tor check plugin"
        "Open Access DOI rewrite"
        "Hostnames plugin"
        "Unit converter plugin"
        "Tracker URL remover"
      ];
    };
  };
}
