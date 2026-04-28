{ pkgs, ... }:

{
  virtualisation = {
    docker = {
      enable = true;
      enableOnBoot = true;
    };

    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
        swtpm.enable = true;
      };
    };

    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  users.users.user.extraGroups = [
    "docker"
    "libvirtd"
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    virt-viewer
    swtpm
    virtio-win
    gnome-boxes
  ];
}
