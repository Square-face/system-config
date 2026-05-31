{ config, lib, ... }:
{
  options.pipewire = {
    lowLatency = lib.mkEnableOption "Enable low latency pipewire profile";
  };

  config.services.pipewire = {
    enable = lib.mkDefault true;
    audio.enable = lib.mkDefault true;
    pulse.enable = lib.mkDefault true;
    jack.enable = lib.mkDefault true;

    alsa.enable = lib.mkDefault true;
    alsa.support32Bit = lib.mkDefault true;
  };

  config.services.pipewire.extraConfig = lib.mkIf config.pipewire.lowLatency {
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
  };
}
