{
  config,
  extras,
  pkgs,
  lib,
  ...
}: let
  cfg = config.metrics;
  host = config.networking.hostName;
in {
  options.metrics = {
    enable = lib.mkEnableOption "Enable alloy agent to collect metrics";
    sources = with extras.options; {
      node = mkEnabledOption "Enable node exporter";
      smartctl = mkEnabledOption "Enable smartctl exporter";
      cadvisor = mkEnabledOption "Enable cadvisor exporter";

      docker = mkEnabledOption "Enable docker log collecting";
      journal = mkEnabledOption "Enable journal log collecting";
    };

    loki_url = lib.mkOption {
      description = "Loki remote write endpoint url";
      type = lib.types.str;
      example = "http://10.0.0.1:3100/loki/api/v1/push";
    };
    prom_url = lib.mkOption {
      description = "Prometheus remote write endpoint url";
      type = lib.types.str;
      example = "http://10.0.0.1:9090/api/v1/write";
    };
  };
  config = lib.mkIf cfg.enable {
    alloy = {
      enable = true;
      loki = {
        write."central".endpoint.url = cfg.loki_url;

        # Journal
        source."journal" = lib.mkIf cfg.sources.journal {
          kind = "journal";
          forward_to = [ "loki.relabel.journal.receiver" ];
          labels = {
            instance = host;
            job="journal";
          };
        };

        relabel."journal" = lib.mkIf cfg.sources.journal {
          forward_to = [ "loki.write.central.receiver" ];
          rule = {
            source_labels = [ "__journal__systemd_unit" ];
            target_label  = "unit";
          };
        };

        # Docker
        source."docker" = lib.mkIf cfg.sources.docker {
          kind = "api";
          forward_to = [ "loki.write.central.receiver" ];
          http = {
            listen_address = "127.0.0.1";
            listen_port = 3100;
          };
          labels = {
            instance = host;
            job = "docker";
          };
        };
      };

      prometheus = {
        remote_write."central".endpoint.url = cfg.prom_url;

        exporter."containers".kind = lib.mkIf cfg.sources.cadvisor "cadvisor";
        exporter."node_exporter" = lib.mkIf cfg.sources.node {
          kind = "unix";
          set_collectors = [ "cpu" "cpufreq" "meminfo" "netdev" "diskstats" "filesystem" "stat" "processes" ];
          netdev.device_exclude = "veth.*|br-.*|lo";
          filesystem.mount_points_exclude = "/nix/store";
        };

        scrape."metrics_120s" = let
          smartctl = {
            job         = "smartctl";
            instance    = "frank";
            __address__ = "127.0.0.1:9633";
          };
        in {
          scrape_interval = "120s";
          scrape_timeout = "5s";
          forward_to = [ "prometheus.remote_write.central.receiver" ];
          targets = [ ]
            ++ (lib.optional cfg.sources.smartctl [smartctl])
            ++ (lib.optional cfg.sources.cadvisor "prometheus.exporter.cadvisor.containers.targets");
        };

        scrape."metrics_5s" = {
          scrape_interval = "5s";
          scrape_timeout = "1s";
          forward_to = [ "prometheus.remote_write.central.receiver" ];
          targets = lib.optional cfg.sources.node "prometheus.exporter.unix.node_exporter.targets";
        };
      };
    };

    # Systemd Services
    systemd.services.prometheus-smartctl-exporter =
      let
        exporter = pkgs.writeShellScript "smartctl-exporter.sh" ''
          ${pkgs.prometheus-smartctl-exporter}/bin/smartctl_exporter \
            --web.listen-address 127.0.0.1:9633
        '';
      in
      {
        enable = cfg.sources.smartctl;
        after = [ "network.target" ];
        wantedBy = [ "default.target" ];
        serviceConfig = {
          User = "root";
          ExecStart = "${exporter}";
        };
      };
  };
}
