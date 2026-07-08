{ ... }:
{
  services.unbound = {
    enable = true;
    settings = {
      server = {
        # Listen on localhost and your LAN interface gateway IPs
        interface = [
          "127.0.0.1"
          "10.0.0.1"
          "fd00:1234:5678::1"
        ];
        port = 53;

        # Access control security
        access-control = [
          "127.0.0.0/8 allow"
          "10.0.0.0/24 allow"
          "fd00:1234:5678::/64 allow"
        ];

        # --- Native DNS64 Translation Engine ---
        module-config = "\"dns64 validator iterator\"";
        dns64-prefix = "64:ff9b::/96";
        dns64-synthall = "yes";

        # --- Local Domain Management (Replaces dnsmasq's aliases) ---
        local-zone = "\"lan.\" static";
        local-data = [
          "\"frank.lan. IN A 10.0.0.1\""
          "\"home.lan. IN A 10.0.0.1\""
          "\"frank.lan. IN AAAA fd00:1234:5678::1\""
          "\"home.lan. IN AAAA fd00:1234:5678::1\""
        ];
      };

      # Forward external queries to secure upstream servers
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1"
            "8.8.8.8"
          ];
        }
      ];
    };
  };

  # Make sure systemd-resolved doesn't conflict
  services.resolved.enable = false;
}
