{
  system.stateVersion = "25.05";

  nix.buildMachines = [
    {
      hostName = "threadripper";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      # if the builder supports building for multiple architectures,
      # replace the previous line by, e.g.
      # systems = ["x86_64-linux" "aarch64-linux"];
      maxJobs = 50;
      speedFactor = 2;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  # nix.extraOptions = ''
  #   	  builders-use-substitutes = true
  #   	'';

  imports = [
    ./modules/pkgs.nix
    ./modules/fonts.nix
    ./modules/users.nix
    ./modules/stylix.nix
    ./modules/nvidia.nix
    ./modules/locale.nix
    ./modules/environment.nix
    ./modules/hardware-extra.nix
    ./hardware-configuration.nix
  ];
}
