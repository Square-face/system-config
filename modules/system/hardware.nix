{ config, lib, ... }:
{
  options.graphics.enable = lib.mkEnableOption "Enable hardware graphics";
  options.bluetooth.enable = lib.mkEnableOption "Enable hardware graphics";

  config = {
    hardware.graphics.enable = config.graphics.enable;
    hardware.bluetooth.enable = config.bluetooth.enable;
  };
}
