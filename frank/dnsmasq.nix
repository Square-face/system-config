{ lib, ... }:
{
  services.dnsmasq = {
    enable = true;
    settings = {
      # sensible behaviours
      domain-needed = true;
      bogus-priv = true;
      no-resolv = true;

      # Cache dns queries.
      cache-size = 1000;
      # upstream DNS servers
      server = [
        "1.1.1.1"
        "8.8.8.8"
        "9.9.9.9"
      ];

      dhcp-range = [ "br0,10.0.0.128,10.0.0.254,24h" ];
      interface = "br0";
      dhcp-host = "10.0.0.1";

      # local domains
      local = "/lan/";
      domain = "lan";
      expand-hosts = true;

      no-hosts = true;
      address = [
        "/frank.lan/10.0.0.1"
        "/home.lan/10.0.0.1"
      ];
    };
  };

  # Disable resolved as it tries to do dnsmasq's job
  services.resolved.enable = lib.mkForce false;
}
