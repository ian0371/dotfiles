{ config
, lib
, pkgs
, modulesPath
, ...
}:
{
  imports = [ ];

  boot.initrd.availableKernelModules = [ "nvme" "virtio_pci" "xhci_pci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/3e22cd54-2f0e-4615-8db5-eb5edf4fe56c";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/57DD-4119";
    fsType = "vfat";
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/ab526def-dd27-4ded-af89-e163d3ec0b48";
  }];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
