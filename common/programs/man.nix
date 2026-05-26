{pkgs, lib, config, ...}: let
  cfg = config.man;
in {
  options.man = {
    enable = lib.mkOption {
      description = "Enable man pages";
      type = lib.types.bool;
      default = true;
    };
  };

  config.environment.systemPackages = lib.mkIf cfg.enable (with pkgs; [
    man-pages
    man-pages-posix
  ]);
}
