{ ... }:
{
  services.tayga = {
    enable = true;

    ipv4.address = "10.0.0.1";
    ipv6.address = "fd00:1234:5678::1";

    ipv4.router.address = "192.168.255.1";
    ipv6.router.address = "64:ff9b::1";

    ipv4.pool.address = "192.168.255.0";
    ipv4.pool.prefixLength = 24;
    
    ipv6.pool.address = "64:ff9b::";
    ipv6.pool.prefixLength = 96;
  };

  networking.nat.internalIPs = [ 
    "10.0.0.0/24" 
    "192.168.255.0/24"
  ];
}
