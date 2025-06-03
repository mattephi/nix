{
  pkgs,
  config,
  ...
}:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Required for Wayland
    modesetting.enable = true; # Required for Wayland
    # Required for hibernate
    powerManagement.enable = true;
    # Turns off gpu when not in use
    powerManagement.finegrained = false;
    # Use open-source kernel module
    open = true;
    # Enable nvidia-settings menu
    nvidiaSettings = true;
    # Off for better webgl performance
    forceFullCompositionPipeline = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
