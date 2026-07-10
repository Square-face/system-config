{
  fileSystems."/persist".neededForBoot = true;

  fileSystems."/etc/ssh" = {
      depends = ["/persist"];
      device = "/persist/etc/ssh";
      fsType = "none";
      options = ["bind"];
      neededForBoot = true;
  };

  disko.devices = {
    nodev = {
      "/" = {
        fsType = "tmpfs";
        mountOptions = ["size=5G" "mode=1755" "uid=0" "gid=0"];
      };
      "/home/sq8" = {
        fsType = "tmpfs";
        mountOptions = ["size=5G" "mode=1700" "uid=1000"];
      };
    };
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              label = "boot";
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "cryptroot";
                # postCreateHook = "systemd-cryptenroll --fido2-device=auto /dev/nvme0n1p2";
                passwordFile = "/tmp/disk.pass";
                settings = {
                  crypttabExtraOpts = ["fido2-device=auto" "token-timeout=10"];
                  allowDiscards = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          persistent = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = ["-f"];
              subvolumes."/home" = {
                mountOptions = [ "compress=zstd" ];
                mountpoint = "/home";
              };

              subvolumes."/home/sq8/persist" = {
                mountOptions = [ "X-mount.mkdir=0700" ];
                mountpoint = "/home/sq8/.persist";
              };

              subvolumes."/nix" = {
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
                mountpoint = "/nix";
              };

              subvolumes."/persist" = {
                mountOptions = [ "compress=zstd" ];
                mountpoint = "/persist";
              };
            };
          };
          swap = {
            size = "64G";
            content = {
              type = "swap";
              resumeDevice = true;
            };
          };
        };
      };
    };
  };
}
