{ lib, ... }:
{
  programs.nh.enable = lib.mkDefault true;
  programs.nh.clean = {
    enable = true;
    extraArgs = "--optimise";
  };
}
