{ config, lib, ... }:
{
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  locale.swedish = true;
  bootloader.enable = true;
  flakes.enable = true;
  docker.enable = true;
  sshd.enable = true;

  rootbash.enable = true;
  rootbash.color = ''\e[38;5;226m\'';

  services.openssh.listenAddresses = [
    {
      addr = "10.0.0.1";
      port = 22;
    }
    {
      addr = "10.2.2.1";
      port = 22;
    }
  ];

  wg.shitcloud = {
    enable = true;
    dns = false; # Prevent dns server from exposing internal service names
    ip = "10.2.2.1";
  };

  sq8.enable = true;
  sq8.trust = true;

  nh.enable = true;

  metrics.enable = true;
  metrics.prom_url = "http://10.2.0.1:9090/api/v1/write";
  metrics.loki_url = "http://10.2.0.1:3100/loki/api/v1/push";

  imports = [
    ./cloudflared.nix
    ./services/nginx.nix
    # ./services/tayga.nix
    # ./services/unbound.nix
    ./borg.nix
    ./networking.nix
    ./filesystem.nix
    ./hardware.nix
    ./secrets.nix
    ./services/home-assistant.nix
    ./services/dnsmasq.nix
    ./services/navidrome.nix
    ./services/weechat.nix
  ];
}
