{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  obs.enable = true;

  shitcloud.vpn.enable = true;
  shitcloud.vpn.dns = false; # Prevent dns server from exposing internal service names
  dns.enable = true;
  dns.DoH = true;

  imports = [
    ./filesystem.nix
    ./networking.nix
    ./hardware.nix
    ./secrets.nix
  ];
}
