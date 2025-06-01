{
  config,
  pkgs,
  lib,
  ...
}:

{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  security.rtkit.enable = true; # Real-time scheduling
  virtualisation.docker = {
    enable = true;
  };

  # TODO: Remnawave running on the host
  # implement declaratively instead.
  # Issue: unable to pass secret to the
  # prisma run to resolve DB connection.

  services.journald.storage = "persistent";

  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      443
      8443
    ];
    # interfaces.docker0 = {
    #   allowedTCPPorts = [
    #     3003
    #   ];
    # };
    # TODO: either fix interface name or
    # find another solution or dynamically
    # update this field based on network.
    interfaces.br-f5cb8ddccbe3 = {
      allowedTCPPorts = [
        3003
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
  ];

  programs = {
    fish.enable = true;
  };

  services = {
    openssh.enable = true;
  };

  services.mtprotoproxy = {
    enable = true;
    users = { };
  };

  services.caddy = {
    enable = true;
    configFile = "${config.sops.templates."Caddyfile".path}";
    package = pkgs.caddy.withPlugins {
      plugins = [
        "github.com/mholt/caddy-webdav@v0.0.0-20241008162340-42168ba04c9d"
        "github.com/mholt/caddy-l4@v0.0.0-20250428144642-57989befb7e6"
      ];
      hash = "sha256-ztG96Y3CmnC6GxP/i9B95OiLMoDieKAqVL/sjHlM+KU=";
    };
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
        secret_key = config.sops.templates.searx.path;
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

  systemd.services.init-litellm-network = {
    description = "Create the network bridge for litellm.";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "oneshot";
    script = ''
          check=$(${pkgs.docker}/bin/docker network ls | grep "litellm-bridge" || true)
      	  if [ -z "$check" ]; then
      	      ${pkgs.docker}/bin/docker network create litellm-bridge
      	  else
         	    echo "litellm-bridge already exists in docker"
       	  fi
      	'';
  };

  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    "open-webui" = {
      image = "ghcr.io/open-webui/open-webui:main";
      hostname = "open-webui";
      ports = [
        "127.0.0.1:3001:8080"
      ];
      volumes = [
        "open-webui-data:/app/backend/data"
      ];
      environmentFiles = [
        "${config.sops.templates."open-webui.env".path}"
      ];
      networks = [
        "litellm-bridge"
      ];
      extraOptions = [
        "--add-host"
        "host.docker.internal:host-gateway"
      ];
    };
    "litellm" = {
      image = "ghcr.io/berriai/litellm:main-latest";
      hostname = "litellm";
      volumes = [
        "${config.sops.templates."litellm".path}:/app/config.yaml"
      ];
      environmentFiles = [
        "${config.sops.templates."litellm.env".path}"
      ];
      ports = [
        "127.0.0.1:3004:4000"
      ];
      networks = [
        "litellm-bridge"
      ];
      cmd = [
        "--config"
        "/app/config.yaml"
        "--detailed_debug"
      ];
      dependsOn = [
        "litellm-db"
      ];
    };
    "litellm-db" = {
      image = "postgres:16";
      hostname = "litellm-db";
      environmentFiles = [
        "${config.sops.templates."litellm.postgres.env".path}"
      ];
      networks = [
        "litellm-bridge"
      ];
      # ports = [
      #   "127.0.0.1:5432:5432"
      # ];
      volumes = [
        "postgres_data:/var/lib/postgresql/data"
      ];
    };
  };

  # TODO: move mtprotoproxy to ns-beta

  systemd.services.mtprotoproxy.serviceConfig = {
    LoadCredential = [ "config:${config.sops.templates."config.py".path}" ];
    ExecStart = lib.mkForce ''
      ${
        pkgs.mtprotoproxy.overrideAttrs (old: {
          version = "latest";
          patches = old.patches or [ ] ++ [
            ../../../../overlays/modules/mtprotoproxy/0-disable-pool.patch
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
