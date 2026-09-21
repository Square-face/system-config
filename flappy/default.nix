{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  tlp.enable = true;
  audio.enable = true;
  flakes.enable = true;
  docker.enable = true;
  upower.enable = true;
  graphics.enable = true;
  bluetooth.enable = true;
  bootloader.enable = true;

  locale.swedish = true;

  ludd = {
    ca.enable = true;
    krb.enable = true;
    vpn = {
      enable = true;
      ip = "192.168.69.22";
    };
  };
  wg.shitcloud = {
    enable = true;
    ip = "10.2.100.4";
  };

  dns.enable = true;
  dns.DoH = true;

  sshd.enable = true;

  sq8.enable = true;
  sq8.trust = true;

  nh.enable = true;
  obs.enable = true;

  imports = [
    ./filesystem.nix
    ./networking.nix
    ./hardware.nix
    ./secrets.nix
  ];
}
