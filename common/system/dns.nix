{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dns;
in
{
  options.dns = {
    enable = lib.mkEnableOption "Enable dnsmasq for dns";
    block = lib.mkOption {
      description = "Configure dns to block certain categories of domains.";
      type = lib.types.submodule {
        options = {
          adBlock = lib.mkEnableOption "Blocks known malware and adblock domains.";
          fakenews = lib.mkEnableOption "Blocks known fakenews domains.";
          gambling = lib.mkEnableOption "Blocks known gambling domains.";
          porn = lib.mkEnableOption "Blocks known porn domains.";
          social = lib.mkEnableOption "Blocks known social media domains.";
        };
      };
      default = { };
    };
    DoH = lib.mkOption {
      description = "Use Dns-over-Https and don't listen to dhcp.";
      type = lib.types.bool;
      default = true;
    };
    extraServers = lib.mkOption {
      description = "Extra dns servers to configure";
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = [ "/local/10.0.0.1#53" ];
    };
  };

  config =
    let
      # Download all hosts files
      hosts = builtins.fetchTarball {
        url = "https://github.com/StevenBlack/hosts/archive/refs/tags/3.16.115.tar.gz";
        sha256 = "02jhr67b5f9hqam93blc23w2d8jsqh6zjgbmdl2vs4glf4m1gsff";
      };

      # Filter the names of the active categories
      categories = lib.filter (c: cfg.block.${c} && c != "adBlock") (lib.attrNames cfg.block);

      # Construct list of files to add to dnsmasq
      blocklist =
        (builtins.map (cat: "${hosts}/alternates/${cat}-only/hosts") categories)
        ++ lib.optional cfg.block.adBlock "${hosts}/hosts";

      # List of dns servers
      servers =
        cfg.extraServers
        ++ lib.optionals cfg.DoH [
          "::1#5053"
          "127.0.0.1#5053"
        ];
    in
    lib.mkIf cfg.enable {

      # Force the system to use dnsmasq for dns if DoH is enabled
      networking.networkmanager.dns = lib.mkIf cfg.DoH "none";
      networking.nameservers = lib.mkIf cfg.DoH [
        "127.0.0.1"
        "::1"
      ];

      services.dnsmasq.enable = true;
      services.dnsmasq.resolveLocalQueries = true;
      services.dnsmasq.settings = {
        # Dont listen to the system if DoH is enabled
        no-resolv = cfg.DoH;

        bind-interfaces = true;
        listen-address = [
          "127.0.0.1"
          "::1"
        ];

        server = servers;
        addn-hosts = blocklist;
      };

      # DNS Over HTTPS Proxy
      services.dnscrypt-proxy = lib.mkIf cfg.DoH {
        enable = true;
        settings = {
          # Let systemd do the listening
          listen_addresses = [ ];

          # Dns providers with DoH enabled
          server_names = [
            "cloudflare"
            "cloudflare-ipv6"
            "quad9-dnscrypt-ip4-nofilter-ecs-pri"
            "quad9-dnscrypt-ip6-nofilter-ecs-pri"
          ];

          require_dnssec = true;
          require_nofilter = true;

          http3 = true;
          netprobe_timeout = 2;

          cache = false; # handled by dnsmasq

          bootstrap_resolvers = [
            "9.9.9.9:53"
            "1.1.1.1:53"
          ];
        };
      };

      systemd.sockets.dnscrypt-proxy =
        let
          addresses = [
            "127.0.0.1:5053"
            "[::1]:5053"
          ];
        in
        lib.mkIf cfg.DoH {
          description = "dnscrypt-proxy listening socket";
          wantedBy = [ "sockets.target" ];
          before = [ "dnscrypt-proxy.service" ];

          listenStreams = addresses;
          listenDatagrams = addresses;
        };
    };
}
