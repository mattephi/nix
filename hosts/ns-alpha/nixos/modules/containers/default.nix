{

  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  imports = [
    ./mkfd
    ./maybe
    ./litellm
  ];
}
