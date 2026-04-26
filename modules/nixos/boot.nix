{ config, ... }:

{
  boot.loader = {
    systemd-boot.enable = false;
    efi = {
      canTouchEfiVariables = false;
      efiSysMountPoint = "/boot";
    };
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";
      forceInstall = true;
      efiInstallAsRemovable = true;
      useOSProber = true;
      splashImage = null;
      minegrub-world-sel = {
        enable = true;
        customIcons = with config.system; [
          {
            inherit name;
            lineTop = with nixos; distroName + " " + codeName + " (" + version + ")";
            lineBottom = "Survival Mode, Version: " + nixos.release;
            imgName = "nixos";
          }
        ];
      };
    };
  };
}
