{ ... }: {
  rootbash.color = ''\e[38;5;226m\'';

  # System
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Networking
  networking.hostName = "frank";
  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.interfaces.br0.useDHCP = false;
  networking.interfaces.eno1.useDHCP = false;

  networking.bridges.br0.interfaces = ["eno1"];

  networking.interfaces.br0.ipv4 = {
    addresses = [{
      address = "192.168.8.10";
      prefixLength = 24;
    }];
  };
  networking.defaultGateway = {
    address = "192.168.8.1";
    interface = "br0";
  };
  networking.nameservers = [ "127.0.0.1" ]; # PIhole

  # Filesystems
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/96522a16-91d2-4e30-9d3f-a15056cf6f65";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/54F7-A196";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  fileSystems."/mnt/backups" = {
    device = "/dev/disk/by-uuid/83fd766d-7cf6-4e43-ae32-09d6eda8de70";
    fsType = "ext4";
  };

  swapDevices = [{
    device = "/dev/disk/by-uuid/29bea1d4-e8c6-4487-91cc-ea7efafe70ac";
  }];
}

