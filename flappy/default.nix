{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  obs.enable = true;

  wg.ludd = {
    enable = true;
    ip = "192.168.69.22";
  };
  wg.shitcloud = {
    enable = true;
    ip = "10.2.100.4";
  };

  dns.enable = true;
  dns.DoH = true;

  sq8.enable = true;
  sq8.trust = true;

  imports = [
    ./filesystem.nix
    ./networking.nix
    ./hardware.nix
    ./secrets.nix
  ];
}
