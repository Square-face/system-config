{ pkgs, lib, ... }:
{
  virtualisation.docker = {
    enable = lib.mkDefault true;
    rootless.setSocketVariable = true;
    # autoPrune.enable = lib.mkDefault true;
  };
}
