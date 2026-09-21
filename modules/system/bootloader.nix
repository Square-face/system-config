{ config, lib, ... }:let
  cfg = config.bootloader;
in
{
  options.bootloader = {
    enable = lib.mkEnableOption "Enable systemd-boot as bootloader";
  };
  config = lib.mkIf cfg.enable {
    boot.loader.systemd-boot = {
      enable = true;

      editor = false; # Recomended to be false as per the docs
      memtest86.enable = true;
    };
  };
}
