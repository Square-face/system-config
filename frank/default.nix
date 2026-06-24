{ config, lib, ... }:
{
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  rootbash.color = ''\e[38;5;226m\'';

  imports = [
    ./cloudflared.nix
    ./services/nginx.nix
    ./services/tayga.nix
    ./borg.nix
    ./services/unbound.nix
    ./networking.nix
    ./filesystem.nix
    ./hardware.nix
    ./services/home-assistant.nix
    ./services/dnsmasq.nix
  ];
}
