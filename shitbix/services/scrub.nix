{ pkgs, ... }: {
  systemd.timers."xfs-defrag" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Unit = "xfs-defrag.service";
    };
  };

  systemd.services.xfs-defrag = {
    bindsTo = ["mnt-bulk.mount"];
    description = "Periodically optimize xfs filesystem layout";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      ExecStart = "${pkgs.xfsprogs}/bin/xfs_fsr -v";
      IOSchedulingClass = "idle";
    };
  };
}
