{pkgs, lib, ...}: {
  services.alloy.enable = true;

  environment.systemPackages = with pkgs; [prometheus-smartctl-exporter];

  systemd.services.prometheus-smartctl-exporter = let
    exporter = pkgs.writeShellScript "smartctl-exporter.sh" ''
      ${pkgs.prometheus-smartctl-exporter}/bin/smartctl_exporter \
        --web.listen-address 127.0.0.1:9633
    '';
  in {
    enable = true;
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      User = "root";
      ExecStart = "${exporter}";
    };
  };

}
