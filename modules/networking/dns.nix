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

    runtimeConfDir = lib.mkOption {
      description = "Directory to use for runtime configuration changes";
      type = lib.types.str;
      default = "/run/dnsmasq";
    };

    addServer = lib.mkOption {
      description = ''
        !!DO NOT SET THIS VALUE!!.
        Creates a shell command that adds a new dns server.

        Example postup for wireguard: 
        postUp = dns.addServer "vpn" "10.30.0.1";
        10.30.0.1 will now be temporarily adde to dnsmasq for .vpn domains when the vpn starts.
      '';
      type = lib.types.unspecified;
    };

    delServer = lib.mkOption {
      description = ''
        !!DO NOT SET THIS VALUE!!.
        Creates a shell command that removes a new server.

        Example postup for wireguard: 
        postDown = dns.delServer "vpn" "10.30.0.1";
        Removes 10.30.0.1 for .vpn from dnsmasq temp config.
      '';
      type = lib.types.unspecified;
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
    lib.mkMerge [
      (lib.mkIf cfg.enable {

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
          resolv-file = lib.mkIf cfg.DoH "";

          bind-interfaces = true;
          listen-address = [
            "127.0.0.1"
            "::1"
          ];

          server = servers;

          addn-hosts = blocklist;
          servers-file = "/run/dnsmasq/servers.conf";
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

        systemd.tmpfiles.rules = [
          "d ${cfg.runtimeConfDir} 0755 root root -"
          "f ${cfg.runtimeConfDir}/servers.conf 0644 root root -"
        ];
      })
      {
        dns.addServer = domain: ip: ''
          line='server=/${domain}/${ip}'
          file='${cfg.runtimeConfDir}/servers.conf'
          if ! grep "$line" "file" 2> /dev/null; then
            echo "$line" >> $file
          fi
          systemctl reload dnsmasq
        '';
        dns.delServer = domain: ip: ''
          ${pkgs.gnused}/bin/sed -i '\|server=/${domain}/${ip}|d' ${cfg.runtimeConfDir}/servers.conf
          systemctl reload dnsmasq
        '';
      }
    ];
}
