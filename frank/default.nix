{ config, lib, ... }:
{
  system.stateVersion = "25.11";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  rootbash.color = ''\e[38;5;226m\'';

  imports = [
    ./cloudflared.nix
    ./nginx.nix
    ./borg.nix
    ./networking.nix
    ./filesystem.nix
    ./hardware.nix
    ./home-assistant.nix
    ./dnsmasq.nix
  ];
}
