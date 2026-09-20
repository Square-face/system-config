{ config, lib, ... }:
{
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

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

  shitcloud.vpn.enable = true;
  shitcloud.vpn.dns = false; # Prevent dns server from exposing internal service names
  dns.enable = true;
  dns.DoH = true;

  sq8.enable = true;
  sq8.trust = true;

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
  ];
}
