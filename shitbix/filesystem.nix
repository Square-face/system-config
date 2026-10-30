{pkgs, ...}: {
  services.lvm.boot.thin.enable = true;
  boot.initrd.kernelModules = [
    "dm-snapshot"
    "dm-raid"
    "dm-cache-default"
  ];

  fileSystems."/" =
    { device = "/dev/mapper/vg-root";
      fsType = "ext4";
    };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/12CE-A600";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  fileSystems."/mnt/backups" = {
    device = "/dev/disk/by-uuid/15842062-b03c-4eba-bf56-49f34d1d59a5";
    fsType = "ext4";
  };

  boot.swraid.enable = true;
  fileSystems."/mnt/bulk" = {
    device = "/dev/disk/by-uuid/6b204755-4a42-4c48-a258-d52a9d1ef3e4";
    fsType = "xfs";
  };

  boot.supportedFilesystems = [ "nfs" ];
  fileSystems."/mnt/media/legacy" = {
    device = "10.2.0.1:/media/legacy";
    fsType = "nfs";
    options = [ "x-systemd.requires=wg-quick-shitcloud.service" ];
  };

  environment.systemPackages = [ pkgs.mergerfs ];
  fileSystems."/mnt/merged/legacy" = {
    device = "/mnt/bulk/staging/legacy:/mnt/media/legacy";
    depends = [ "/mnt/bulk" "/mnt/media/legacy" ];
    fsType = "fuse.mergerfs";
    options = [
      "cache.files=off"
      "category.create=ff"
      "func.getattr=newest"
      "dropcacheonclose=false"
    ];
  };
}
