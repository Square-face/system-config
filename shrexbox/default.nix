{
  pkgs,
  lib,
  config,
  ...
}:
{
  pipewire.lowLatency = false;
  pipewire.raop = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  wg.ludd = {
    enable = true;
    ip = "192.168.69.23";
  };
  wg.shitcloud = {
    enable = true;
    ip = "10.2.100.1";
  };

  obs.enable = true;

  dns.enable = true;
  dns.DoH = true;

  sq8.enable = true;
  sq8.trust = true;

  quisita.enable = true;
  secoffee.enable = true;

  imports = [
    ./networking.nix
    ./hardware.nix
    ./secrets.nix

    ./disko.nix
    { hardware.facter.reportPath = ./facter.json; }
  ];
}
