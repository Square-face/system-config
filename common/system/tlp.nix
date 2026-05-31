{ lib, ... }:
{
  services.tlp.enable = lib.mkDefault true;
  services.tlp.settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 60;

    START_CHARGE_THRESH_BAT0 = 0; # dummy number for tlp to behave
    STOP_CHARGE_THRESH_BAT0 = 1; # enable battery conservation
  };
}
