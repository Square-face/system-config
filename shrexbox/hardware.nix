{ lib, config, ... }:
{
  hardware.enableRedistributableFirmware = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # swapDevices = [
  #   { device = "/dev/mapper/pool-swap"; }
  # ];
}
