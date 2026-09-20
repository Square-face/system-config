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

  obs.enable = true;

  shitcloud.vpn.enable = true;
  dns.enable = true;

  imports = [
    ./networking.nix
    ./hardware.nix
    ./secrets.nix

    ./disko.nix
    { hardware.facter.reportPath = ./facter.json; }
  ];
}
