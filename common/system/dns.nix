{ config, lib, ... }: let
  cfg = config.dns;
in {
  options.dns = {
    enable = lib.mkEnableOption "Enable dnsmasq for dns";
    DoH = lib.mkOption {
      description = "Use Dns-over-Https and don't listen to dhcp.";
      type = lib.types.bool;
      default = true;
    };
    extraServers = lib.mkOption {
      description = "Extra dns servers to configure";
      type = lib.types.listOf lib.types.str;
      default = [];
      example = ["/local/10.0.0.1#53"];
    };
  };

  config = lib.mkIf cfg.enable {
    networking.nameservers = lib.mkIf cfg.DoH [ "127.0.0.1" "::1" ];
    networking.networkmanager.dns = lib.mkIf cfg.DoH "none";

    services.dnsmasq.enable = true;
    services.dnsmasq.resolveLocalQueries = !cfg.DoH;
    services.dnsmasq.settings = {
        no-resolv = cfg.DoH;
        server = cfg.extraServers ++ lib.optionals cfg.DoH [
          "::1#5053"
          "127.0.0.1#5053"
        ];

        listen-address = [ "127.0.0.1" "::1" ];
        bind-interfaces = true;
    };
  
    services.dnscrypt-proxy = lib.mkIf cfg.DoH {
      enable = true;
      settings = {
        listen_addresses = [ "127.0.0.1:5053" "[::1]:5053" ];
        
        server_names = [
          "cloudflare" "cloudflare-ipv6"
          "quad9-dnscrypt-ip4-nofilter-ecs-pri" "quad9-dnscrypt-ip6-nofilter-ecs-pri"
        ];
        
        require_dnssec = true;
        require_nofilter = true;
  
        http3 = true;
        cache = false;

        netprobe_timeout = 2;
        bootstrap_resolvers = [ "9.9.9.9:53" "1.1.1.1:53" ];
      };
    };
  };
}
