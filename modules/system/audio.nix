{ config, lib, ... }:
let
  cfg = config.audio;
in
{
  options.audio = {
    enable = lib.mkEnableOption "Enable pipewire for sound";
    raop = lib.mkEnableOption "Enable raop discovery (also enables avahi)";
    lowLatency = lib.mkEnableOption "Enable low latency pipewire profile";
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = lib.mkDefault true;
      audio.enable = lib.mkDefault true;

      pulse.enable = lib.mkDefault true;
      jack.enable = lib.mkDefault true;
      alsa.enable = lib.mkDefault true;
      alsa.support32Bit = lib.mkDefault true;


      extraConfig = lib.mkIf cfg.lowLatency {
        pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 96000;
            "default.clock.quantum" = 32;
            "default.clock.min-quantum" = 16;
            "default.clock.max-quantum" = 32;
          };
        };
        pipewire-pulse."92-low-latency" = {
          "context.modules" = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                "pulse.default.req" = "16/96000";
                "pulse.min.req" = "16/96000";
                "pulse.max.req" = "32/96000";
                "pulse.min.quantum" = "16/96000";
                "pulse.max.quantum" = "32/96000";
              };
            }
          ];
          "stream.properties" = {
            "node.latency" = "32/96000";
            "resample.quality" = 1;
          };
        };

        pipewire."99-raop" = lib.mkIf cfg.raop {
          "context.modules" = [
            {
              name = "libpipewire-module-raop-discover";
              args = { };
            }
          ];
        };
      };

      raopOpenFirewall = cfg.raop;
    };

    services.avahi = lib.mkIf cfg.raop {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };
  };
}
