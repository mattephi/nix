{
  config,
  pkgs,
  lib,
  ...
}:

{

  sops.secrets."maybe.env" = {
    format = "dotenv";
    sopsFile = ./maybe.env;
  };

  virtualisation.oci-containers.containers."maybe-db" = {
    image = "postgres:16";
    environmentFiles = [
      "${config.sops.secrets."maybe.env".path}"
    ];
    volumes = [
      "maybe_postgres-data:/var/lib/postgresql/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=pg_isready -U $POSTGRES_USER -d $POSTGRES_DB"
      "--health-interval=5s"
      "--health-retries=5"
      "--health-timeout=5s"
      "--network-alias=db"
      "--network=maybe_maybe_net"
    ];
  };
  systemd.services."docker-maybe-db" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-maybe_maybe_net.service"
      "docker-volume-maybe_postgres-data.service"
    ];
    requires = [
      "docker-network-maybe_maybe_net.service"
      "docker-volume-maybe_postgres-data.service"
    ];
    partOf = [
      "docker-compose-maybe-root.target"
    ];
    wantedBy = [
      "docker-compose-maybe-root.target"
    ];
  };
  virtualisation.oci-containers.containers."maybe-redis" = {
    image = "redis:latest";
    volumes = [
      "maybe_redis-data:/data:rw"
    ];
    log-driver = "journald";
    extraOptions = [
      "--health-cmd=[\"redis-cli\", \"ping\"]"
      "--health-interval=5s"
      "--health-retries=5"
      "--health-timeout=5s"
      "--network-alias=redis"
      "--network=maybe_maybe_net"
    ];
  };
  systemd.services."docker-maybe-redis" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-maybe_maybe_net.service"
      "docker-volume-maybe_redis-data.service"
    ];
    requires = [
      "docker-network-maybe_maybe_net.service"
      "docker-volume-maybe_redis-data.service"
    ];
    partOf = [
      "docker-compose-maybe-root.target"
    ];
    wantedBy = [
      "docker-compose-maybe-root.target"
    ];
  };
  virtualisation.oci-containers.containers."maybe-web" = {
    image = "ghcr.io/maybe-finance/maybe:latest";
    environmentFiles = [
      "${config.sops.secrets."maybe.env".path}"
    ];
    volumes = [
      "maybe_app-storage:/rails/storage:rw"
    ];
    ports = [
      "127.0.0.1:3000:3000/tcp"
    ];
    dependsOn = [
      "maybe-db"
      "maybe-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=web"
      "--network=maybe_maybe_net"
    ];
  };
  systemd.services."docker-maybe-web" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-maybe_maybe_net.service"
      "docker-volume-maybe_app-storage.service"
    ];
    requires = [
      "docker-network-maybe_maybe_net.service"
      "docker-volume-maybe_app-storage.service"
    ];
    partOf = [
      "docker-compose-maybe-root.target"
    ];
    wantedBy = [
      "docker-compose-maybe-root.target"
    ];
  };
  virtualisation.oci-containers.containers."maybe-worker" = {
    image = "ghcr.io/maybe-finance/maybe:latest";
    cmd = [
      "bundle"
      "exec"
      "sidekiq"
    ];
    environmentFiles = [
      "${config.sops.secrets."maybe.env".path}"
    ];
    dependsOn = [
      "maybe-redis"
    ];
    log-driver = "journald";
    extraOptions = [
      "--network-alias=worker"
      "--network=maybe_maybe_net"
    ];
  };
  systemd.services."docker-maybe-worker" = {
    serviceConfig = {
      Restart = lib.mkOverride 90 "always";
      RestartMaxDelaySec = lib.mkOverride 90 "1m";
      RestartSec = lib.mkOverride 90 "100ms";
      RestartSteps = lib.mkOverride 90 9;
    };
    after = [
      "docker-network-maybe_maybe_net.service"
    ];
    requires = [
      "docker-network-maybe_maybe_net.service"
    ];
    partOf = [
      "docker-compose-maybe-root.target"
    ];
    wantedBy = [
      "docker-compose-maybe-root.target"
    ];
  };

  # Networks
  systemd.services."docker-network-maybe_maybe_net" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStop = "docker network rm -f maybe_maybe_net";
    };
    script = ''
      docker network inspect maybe_maybe_net || docker network create maybe_maybe_net --driver=bridge
    '';
    partOf = [ "docker-compose-maybe-root.target" ];
    wantedBy = [ "docker-compose-maybe-root.target" ];
  };

  # Volumes
  systemd.services."docker-volume-maybe_app-storage" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect maybe_app-storage || docker volume create maybe_app-storage
    '';
    partOf = [ "docker-compose-maybe-root.target" ];
    wantedBy = [ "docker-compose-maybe-root.target" ];
  };
  systemd.services."docker-volume-maybe_postgres-data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect maybe_postgres-data || docker volume create maybe_postgres-data
    '';
    partOf = [ "docker-compose-maybe-root.target" ];
    wantedBy = [ "docker-compose-maybe-root.target" ];
  };
  systemd.services."docker-volume-maybe_redis-data" = {
    path = [ pkgs.docker ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      docker volume inspect maybe_redis-data || docker volume create maybe_redis-data
    '';
    partOf = [ "docker-compose-maybe-root.target" ];
    wantedBy = [ "docker-compose-maybe-root.target" ];
  };

  # Root service
  # When started, this will automatically create all resources and start
  # the containers. When stopped, this will teardown all resources.
  systemd.targets."docker-compose-maybe-root" = {
    unitConfig = {
      Description = "Root target generated by compose2nix.";
    };
    wantedBy = [ "multi-user.target" ];
  };
}
