{ ... }:
{
  networking.hostName = "shrexbox";
  networking.networkmanager.enable = true;

  dns.enable = true;
  dns.DoH = true;

  ludd.vpn = {
    enable = true;
    ip = "192.168.69.22";
  };
  wg.shitcloud = {
    enable = true;
    ip = "10.2.100.1";
  };

  networking.useDHCP = false;
  networking.dhcpcd.enable = false;
  networking.interfaces.enp14s0.ipv4 = {
    addresses = [
      {
        address = "10.0.0.67";
        prefixLength = 24;
      }
    ];
  };

  networking.defaultGateway = {
    address = "10.0.0.1";
    interface = "enp14s0";
  };

  networking.nameservers = [
    "10.0.0.1"
    "1.1.1.1"
    "8.8.8.8"
  ];
}
