{ lib, config, ... }:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "rtsx_pci_sdmmc"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  swapDevices = [
    { device = "/dev/mapper/vg-swap"; }
  ];
}
