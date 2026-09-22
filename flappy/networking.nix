{ ... }:
{
  networking.hostName = "flappy";
  networking.networkmanager.enable = true;

  dns.enable = true;
  dns.DoH = true;

  ludd.vpn = {
    enable = true;
    ip = "192.168.69.22";
  };
  wg.shitcloud = {
    enable = true;
    ip = "10.2.100.4";
  };
}
