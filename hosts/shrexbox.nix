{ lib, config, ...}: {
  pipewire.lowLatency = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.interfaces.enp14s0.ipv4 = {
    addresses = [{
      address = "192.168.8.3";
      prefixLength = 24;
    }];
  };

  networking.defaultGateway = {
    address = "192.168.8.1";
    interface = "enp14s0";
  };

  networking.nameservers = [ "192.168.8.10" "1.1.1.1" "8.8.8.8" ];

  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  boot.initrd.luks.devices."crypt-lvm" = {
    device = "/dev/disk/by-uuid/dd092f65-0230-40e9-ae8e-d9e8e8182423";
    allowDiscards = true;
  };

  fileSystems."/" = {
    device = "/dev/mapper/vg-root";
    fsType = "btrfs";
    options = [ "subvol=root" ];
  };

  fileSystems."/nix" = {
    device = "/dev/mapper/vg-root";
    fsType = "btrfs";
    options = [ "subvol=nix" ];
  };

  fileSystems."/var/log" = {
    device = "/dev/mapper/vg-root";
    fsType = "btrfs";
    options = [ "subvol=var/log" ];
    neededForBoot = true;
  };

  fileSystems."/home/sq8" = {
    device = "/dev/mapper/vg-root";
    fsType = "btrfs";
    options = [ "subvol=home/sq8" ];
  };
  fileSystems."/home/sq8/Games" = {
    device = "/dev/mapper/vg-games";
    fsType = "xfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1486-F4EA";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [
    { device = "/dev/mapper/vg-swap"; }
  ];
}
