{ ... }:
{
  networking.hostName = "shrexbox";
  networking.networkmanager.enable = true;

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
