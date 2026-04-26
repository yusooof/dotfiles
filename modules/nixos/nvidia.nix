{ config, pkgs, ... }:

{
  # Enable OpenGL
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Load NVIDIA driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    # Use the proprietary NVIDIA driver
    open = false;

    # Modesetting is required for Wayland compositors (e.g. GNOME on Wayland)
    modesetting.enable = true;

    # Enable the NVIDIA settings menu (nvidia-settings)
    nvidiaSettings = true;

    # Use the stable driver package
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # Power management (optional, enable if you have suspend/resume issues)
    powerManagement.enable = false;
    powerManagement.finegrained = false;
  };
}
