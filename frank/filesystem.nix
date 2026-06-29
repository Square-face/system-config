{ ... }:
{
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/96522a16-91d2-4e30-9d3f-a15056cf6f65";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/54F7-A196";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/1TB" = {
    device = "/dev/disk/by-uuid/83fd766d-7cf6-4e43-ae32-09d6eda8de70";
    fsType = "ext4";
  };

  fileSystems."/srv/backups" = {
    depends = ["/mnt/1TB"];
    device = "/mnt/1TB/backups";
    fsType = "none";
    options = ["bind"];
  };

  fileSystems."/srv/music" = {
    depends = ["/mnt/1TB"];
    device = "/mnt/1TB/music";
    fsType = "none";
    options = ["bind"];
  };
}
