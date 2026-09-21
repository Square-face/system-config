{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.obs;
in
{
  options.obs = {
    enable = lib.mkEnableOption "Enable OBS support";
    enableCam = lib.mkOption {
      description = "Enable configuration for the virtual camera to work";
      type = lib.types.bool;
      default = true;
    };
  };
  config = {
    programs.obs-studio.enable = lib.mkDefault cfg.enable;
    programs.obs-studio.enableVirtualCamera = lib.mkDefault cfg.enableCam;
    programs.obs-studio.plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };
}
