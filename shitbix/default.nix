{ config, lib, ... }:
{
  system.stateVersion = "26.05";

  bootloader.enable = true;
  landscape.enable = true;
  locale.swedish = true;
  flakes.enable = true;
  docker.enable = true;
  sshd.enable = true;
  nh.enable = true;

  rootbash.enable = true;
  rootbash.color = ''\e[38;5;11m\'';

  wg.shitcloud = {
    enable = true;
    ip = "10.2.1.1";
  };

  dns.enable = true;
  dns.DoH = false;

  networking.nameservers = ["10.0.3.1"];

  metrics = {
    enable = true;
    prom_url = "http://10.2.0.1:9090/api/v1/write";
    loki_url = "http://10.2.0.1:3100/loki/api/v1/push";
  };

  imports = [
    ./services

    ./nvidia.nix
    ./secrets.nix
    ./hardware.nix
    ./filesystem.nix
    ./networking.nix
  ];
}
