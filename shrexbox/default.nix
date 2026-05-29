{ lib, config, ... }:
{
  pipewire.lowLatency = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  system.stateVersion = "26.05";

  imports = [
    ./filesystem.nix
    ./networking.nix
    ./hardware.nix
  ];

}
