{ pkgs, config, libs, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true; # Required for Wayland
    powerManagement.enable = true; # Required for hibernate
    powerManagement.finegrained = false;
    forceFullCompositionPipeline = false; # NOTE: may cause issues with WebGL
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

}
