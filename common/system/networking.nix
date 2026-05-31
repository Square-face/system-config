{ lib, ... }:
{
  networking.networkmanager.enable = lib.mkDefault true;
  networking.wireguard.enable = lib.mkDefault true;
}
