{ ... }:{

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
}
