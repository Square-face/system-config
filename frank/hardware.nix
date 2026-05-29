{ lib, config, ... }: {
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  swapDevices = [{
    device = "/dev/disk/by-uuid/29bea1d4-e8c6-4487-91cc-ea7efafe70ac";
  }];
}
