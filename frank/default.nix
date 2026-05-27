{ config, lib, ... }: {
  imports = [
    ./cloudflared.nix
    ./nginx.nix
    ./borg.nix
    ./networking.nix
    ./home-assistant.nix
    ./dnsmasq.nix
  ];
  rootbash.color = ''\e[38;5;226m\'';

  # System
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "uas" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

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
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "sv_SE.UTF-8";
    LC_IDENTIFICATION = "sv_SE.UTF-8";
    LC_MEASUREMENT = "sv_SE.UTF-8";
    LC_MONETARY = "sv_SE.UTF-8";
    LC_NAME = "sv_SE.UTF-8";
    LC_NUMERIC = "sv_SE.UTF-8";
    LC_PAPER = "sv_SE.UTF-8";
    LC_TELEPHONE = "sv_SE.UTF-8";
    LC_TIME = "sv_SE.UTF-8";
  };
}

