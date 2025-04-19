{ pkgs, ... }:
{
  # Power management is required for hibernation
  powerManagement.enable = true;
  # Bluetooth support
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  # Modify the bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    # Use the latest kernel
    kernelPackages = pkgs.linuxPackages_latest;
    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
      "nvidia-drm.modeset=1" # Enable Nvidia KMS on kernel level
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1" # Helps with suspend/resume
    ];
    # OS choice hidden. Press any key to show.
    loader.timeout = 0;
    # Nvidia kernel modules
    extraModprobeConfig = ''
      options nvidia-drm modeset=1
      softdep nvidia pre: nvidia-drm
    '';
    # Somehow this breakes hibernation, AVOID
    # initrd.kernelModules = [
    #   "nvidia"
    #   "nvidia_modeset"
    #   "nvidia_drm"
    #   "nvidia_uvm"
    # ];
  };
}
