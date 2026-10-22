{ lib, ... }:
{
  # Enable basic dnsmasq with DoH support
  dns.enable = true; 
  dns.DoH = true;
  dns.block.adBlock = true;

  # Modify the settings since we are a router
  services.dnsmasq.settings = {
    filter-AAAA = true; # No ipv6 :(

    # Unlike the dns module, we also want dnsmasq to listen on external interfaces
    interface = [
      "lo"
      "lan0"
    ];

    listen-address = [
      "::1" # Local
      "127.0.0.1"

      "10.0.0.1" # Lan
    ];

    # IPv4 and IPv6 DHCP pools
    dhcp-range = [ "lan0,10.0.0.128,10.0.0.254,24h" ];

    # We are the dns server
    dhcp-option = [ "option:dns-server,10.0.0.1" ];
  };
}
