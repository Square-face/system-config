{ lib, ... }:
{
  dns.enable = true;
  dns.DoH = true;
  dns.block.adBlock = true;

  services.dnsmasq.settings = {
    # Unlike the dns module, we also want dnsmasq to listen on external interfaces
    interface = [
      "lo"
      "lan0"
    ];
    listen-address = [
      "::1" # Local
      "127.0.0.1"

      "10.0.0.1" # Lan
      "fd00:1234:5678::1"
    ];

    # IPv4 and IPv6 DHCP pools
    dhcp-range = [
      "lan0,10.0.0.128,10.0.0.254,24h"
      "fd00:1234:5678::,ra-stateless,ra-names"
    ];

    # Tell DHCP clients that the router's IPv4/IPv6 addresses are their DNS servers
    dhcp-option = [
      "option:dns-server,10.0.0.1"
      "option6:dns-server,[fd00:1234:5678::1]"
    ];
  };
}
