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
    vpn = {
      enable = true;
      ip = "192.168.69.22";
    };
  };
  wg.shitcloud = {
    enable = true;
    ip = "10.2.100.1";
  };

  dns.enable = true;
  dns.DoH = true;

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
