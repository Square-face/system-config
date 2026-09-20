{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  obs.enable = true;

  shitcloud.vpn.enable = true;
  dns.enable = true;
  dns.DoH = true;

  sq8.enable = true;
  sq8.trust = true;

  wg.ludd = {
    enable = true;
    ip = "192.168.69.22";
  };

  imports = [
    ./filesystem.nix
    ./networking.nix
    ./hardware.nix
    ./secrets.nix
  ];
}
