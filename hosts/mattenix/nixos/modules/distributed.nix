{
  nix.buildMachines = [
    {
      hostName = "threadripper";
      system = "x86_64-linux";
      protocol = "ssh-ng";
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
}
