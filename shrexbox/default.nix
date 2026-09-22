{
  pkgs,
  lib,
  config,
  ...
}:
{
  locale.swedish = true;

  bootloader.enable = true;
  bluetooth.enable = true;
  graphics.enable = true;
  flakes.enable = true;
  docker.enable = true;
  upower.enable = true;
  audio = {
    enable = true;
    lowLatency = false;
    raop = true;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  ludd = {
    ca.enable = true;
    krb.enable = true;
  };

  sq8.enable = true;
  sq8.trust = true;
  quisita.enable = true;
  secoffee.enable = true;

  sshd.enable = true;

  nh.enable = true;
  obs.enable = true;
  gaming.steam.enable = true;

  imports = [
    ./steering-wheel.nix
    ./networking.nix
    ./hardware.nix
    ./secrets.nix

    ./disko.nix
    { hardware.facter.reportPath = ./facter.json; }
  ];
}
