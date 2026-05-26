{ config, lib, pkgs, ... }: {
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "rtsx_pci_sdmmc" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.supportedFilesystems = [ "btrfs" ];

  networking.hostName = "flappy";

  boot.initrd.luks.devices."crypt-lvm" = {
    device = "/dev/disk/by-uuid/dd772d4f-60ea-4175-91ca-28d1b4b5f24b";
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/vg-primary";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/vg-primary";
    fsType = "btrfs";
    options = [ "subvol=nix" "noatime" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/mapper/vg-primary";
    fsType = "btrfs";
    options = [ "subvol=log" ];
    neededForBoot = true;
  };

  fileSystems."/persist" = {
    device = "/dev/mapper/vg-primary";
    fsType = "btrfs";
    options = [ "subvol=persist" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/C0BD-FB46";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    { device = "/dev/mapper/vg-swap"; }
  ];
}
