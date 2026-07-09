{ config, ... }:
{
  networking.hostName = "frank";
  networking.useNetworkd = true;

  networking.nameservers = [ "127.0.0.1" ];

  systemd.network.netdevs = {
    "20-lan0" = {
      netdevConfig = {
        Kind = "bridge";
        Name = "lan0";
      };
    };
    "30-shitcloud" = {
      netdevConfig = {
        Kind = "wireguard";
        Name = "shitcloud";
      };
      wireguardConfig = {
        PrivateKeyFile = config.age.secrets.wg-shitcloud.path;
        RouteTable = "main";
      };
      wireguardPeers = [
        {
          PublicKey = "1XaNV7e/cxm5hRAbLj+/MP/R9oO82aUTL27yb1eeFyU=";
          AllowedIPs = [ "10.2.0.0/16" ];
          Endpoint = "130.240.204.10:51821";
          PersistentKeepalive = 20;
        }
      ];
    };
  };

  systemd.network.networks = {
    "30-shitcloud" = {
      matchConfig.Name = "shitcloud";
      address = [ "10.2.2.1/16" ];
    };
    "30-eno1" = {
      matchConfig.Name = "eno1";
      networkConfig.Bridge = "lan0";
      linkConfig.RequiredForOnline = "enslaved";
    };

    "30-lan0" = {
      matchConfig.Name = "lan0";
      address = [
        "10.0.0.1/24"
        "fd00:1234:5678::1/64"
      ];
      networkConfig.IPv4Forwarding = "yes";
      networkConfig.IPv6Forwarding = "yes";
    };

    "30-enp0s20f0u2" = {
      matchConfig.Name = "enp0s20f0u2";
      networkConfig.DHCP = "yes";
      networkConfig.IPv6AcceptRA = "yes";
      networkConfig.IPv4Forwarding = "yes";
      networkConfig.IPv6Forwarding = "yes";
    };

    "30-nat64" = {
      matchConfig.Name = "nat64";
      networkConfig = {
        IPv4Forwarding = "yes";
        IPv6Forwarding = "yes";
      };
      routes = [
        {
          Destination = "64:ff9b::/96";
        }
      ];
    };
  };

  networking.nat = {
    enable = true;
    externalInterface = "enp0s20f0u2";
    internalInterfaces = [ "lan0" ];
    internalIPs = [ "10.0.0.0/24" ];
  };

  boot.kernel.sysctl = {
    "net.ipv4.conf.all.forwarding" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
    "net.ipv6.conf.enp0s20f0u2.accept_ra" = 2;
  };

  networking.firewall.enable = false;
}
