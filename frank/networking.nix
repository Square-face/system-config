{ config, ... }:
{
  networking.hostName = "frank";
  networking.useNetworkd = true;

  dns.enable = true;
  dns.DoH = true;

  networking.nameservers = [ "127.0.0.1" ];

  systemd.network.netdevs."20-lan0" = {
    netdevConfig = {
      Kind = "bridge";
      Name = "lan0";
    };
  };

  systemd.network.networks = {
    "30-eno1" = {
      matchConfig.Name = "eno1";
      networkConfig.Bridge = "lan0";
      linkConfig.RequiredForOnline = "enslaved";
    };

    "30-lan0" = {
      matchConfig.Name = "lan0";
      address = [
        "10.0.0.1/24"
      ];
      networkConfig.IPv4Forwarding = "yes";
    };

    "30-enp0s20f0u2" = {
      matchConfig.Name = "enp0s20f0u2";
      networkConfig = {
        DHCP = "yes";
        IPv4Forwarding = "yes";
      };
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
  };

  networking.firewall.enable = false;
}
