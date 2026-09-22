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
  };

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
