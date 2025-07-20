{
  config,
  pkgs,
  ...
}:
{

  sops.secrets."litellm.env" = {
    format = "dotenv";
    sopsFile = ./litellm.env;
  };

  sops.secrets."litellm.yaml" = {
    format = "yaml";
    sopsFile = ./litellm.yaml;
    key = "";
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

  virtualisation.oci-containers.containers.litellm = {
    image = "ghcr.io/berriai/litellm:main-latest";
    hostname = "litellm";
    volumes = [
      "${config.sops.secrets."litellm.yaml".path}:/app/config.yaml"
    ];
    environmentFiles = [
      "${config.sops.secrets."litellm.env".path}"
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

  virtualisation.oci-containers.containers.litellm-db = {
    image = "postgres:16";
    hostname = "litellm-db";
    environmentFiles = [
      "${config.sops.secrets."litellm.env".path}"
    ];
    networks = [
      "litellm-bridge"
    ];
    volumes = [
      "postgres_data:/var/lib/postgresql/data"
    ];
  };
}
